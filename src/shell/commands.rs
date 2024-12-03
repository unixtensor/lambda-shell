use std::{fs, io, path::{Path, PathBuf}, process, str::SplitWhitespace};
use color_print::cformat;
use uzers::User;
use super::verbose::Verbose;

trait CommandsVerbose {
	fn command_failure(&self, error: io::Error);
	fn unknown_command(&self, error: io::Error);
	fn cd_error(&self, error: io::Error);
	fn dir_missing(&self, message: String);
	// fn unknown_dir(&self, dir: &OsStr);
}
impl CommandsVerbose for Verbose {
	#[inline]
	fn cd_error(&self, error: io::Error) {
		self.format(
			cformat!("cd: <r,bold>{error}</>"),
			format!("cd: {error}")
		);
	}
	#[inline]
	fn command_failure(&self, error: io::Error) {
		self.eformat(
			cformat!("Command: \"<bold>{error}</>\" failed to start."),
			format!("Command: {:?} failed to start.", error)
		);
	}
	#[inline]
	fn unknown_command(&self, error: io::Error) {
		self.format(
			cformat!("{error}"),
			format!("{error}")
		);
	}
	#[inline]
	fn dir_missing(&self, message: String) {
		self.format(
			cformat!("The directory \"<bold>{message}</>\" does not exist."),
			format!("The directory {message:?} does not exist.")
		);
	}
}

fn set_current_dir(new_path: &Path) -> Option<PathBuf> {
	match std::env::set_current_dir(new_path) {
	    Ok(()) => Some(new_path.to_path_buf()),
	    Err(_) => None,
	}
}

trait ChangeDirectory {
	fn change_directory(&self, args: SplitWhitespace) -> Option<PathBuf>;
	fn specific_user_dir(&self, user: String) -> Option<PathBuf>;
	fn cd_args(&self, vec_args: Vec<String>) -> Option<PathBuf>;
	fn previous_dir(&self);
	fn root(&self) -> Option<PathBuf>;
	fn home(&self) -> Option<PathBuf>;
}
impl ChangeDirectory for Command {
	fn previous_dir(&self) {

	}

	fn root(&self) -> Option<PathBuf> {
		set_current_dir(Path::new("/"))
	}

	fn specific_user_dir(&self, requested_user: String) -> Option<PathBuf> {
		if requested_user == "root" {
			let root_home = PathBuf::from("/root");
			return match root_home.try_exists() {
				Ok(root_folder_exist) => match root_folder_exist {
					true => Some(root_home),
					false => {
						self.verbose.dir_missing("hi".to_string());
						self.home()
					}
				},
				Err(_) => self.home()
			};
		} else {
			for user in unsafe { uzers::all_users().collect::<Vec<User>>() } {
				let user_name = user.name();
				if *requested_user == *user_name {
					let mut user_dir = PathBuf::from("/home");
					user_dir.push(user_name);
					return match user_dir.try_exists() {
						Ok(user_dir_exist) => match user_dir_exist {
							true => Some(user_dir),
							false => {
								self.verbose.dir_missing("hi".to_string());
								self.home()
							}
						},
						Err(_) => self.home()
					}
				}
			}
			None
		}
	}

	fn home(&self) -> Option<PathBuf> {
		match home::home_dir() {
			Some(home_path_buf) => set_current_dir(&home_path_buf),
			None => self.root()
		}
	}

	fn cd_args(&self, vec_args: Vec<String>) -> Option<PathBuf> {
		let string_path = vec_args.concat();
		let new_path = Path::new(string_path.as_str());
		match new_path.is_dir() {
			true => set_current_dir(new_path),
        	false => {
				match new_path.file_name() {
			        Some(file_name) => eprintln!("cd: {:?} is not a directory.", file_name),
			        None => eprintln!("cd: Failed to resolve the file name."),
			    }
				None
			},
	    }
	}

	fn change_directory(&self, args: SplitWhitespace) -> Option<PathBuf> {
		let vec_args = self.args_to_vec(args);
		match vec_args.first() {
			Some(arg) => match arg.as_str() {
				"/" => self.root(),
				"-" => todo!(),
				_ => {
					let mut arg_chars = arg.chars();
					match arg_chars.next() {
						Some(char) => match char == '~' {
					        true => self.specific_user_dir(arg_chars.collect::<String>()),
					        false => self.cd_args(vec_args),
					    }
			        	None => self.home(),
					}
				}
			},
			None => self.home()
		}
	}
}

pub type ProcessExitStatus = Option<process::ExitStatus>;
pub struct Command {
	verbose: Verbose,
	input: String
}
impl Command {
	pub fn new(input: String, verbose: Verbose) -> Self {
		Self {
			input,
			verbose
		}
	}

	pub fn args_to_vec(&self, args: SplitWhitespace) -> Vec<String> {
		args.map(|arg| arg.to_string()).collect()
	}

	pub fn spawn(&self, command_process: io::Result<process::Child>) -> ProcessExitStatus {
		match command_process {
			Ok(mut child) => Some(match child.wait() {
		        Ok(e) => e,
		        Err(s) => {
					self.verbose.command_failure(s);
					return None
				},
		    }),
			Err(e) => {
				self.verbose.unknown_command(e);
				return None
			}
		}
	}

	pub fn exec(&self) -> ProcessExitStatus {
		let mut args = self.input.split_whitespace();
		args.next().and_then(|command| match command {
			"cd" => {
				Self::change_directory(self, args);
				None
			},
			command => self.spawn(process::Command::new(command).args(args).spawn())
		})
	}
}