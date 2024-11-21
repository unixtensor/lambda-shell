use std::{io, path::{Path, PathBuf}, process, str::SplitWhitespace};
use color_print::cformat;
use super::verbose::Verbose;

pub type ProcessExitStatus = Option<process::ExitStatus>;

pub struct Command {
	verbose: Verbose,
	input: String
}

trait CommandsVerbose {
	fn command_failure(&self, error: io::Error);
	fn unknown_command(&self, error: io::Error);
	fn cd_error(&self, error: io::Error);
	// fn unknown_dir(&self, dir: &OsStr);
}
trait ChangeDirectory {
	fn change_directory(&self, args: SplitWhitespace) -> Option<PathBuf>;
	fn set_current_dir(&self, new_path: &Path) -> Option<PathBuf>;
	fn cd_args(&self, vec_args: Vec<String>) -> Option<PathBuf>;
	fn specific_user_dir(&self, arg: String);
	fn root(&self) -> Option<PathBuf>;
	fn home(&self) -> Option<PathBuf>;
	fn previous_dir(&self);
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
	// #[inline]
	// fn unknown_dir(&self, dir: &OsStr) {
	// 	self.format(
	// 		cformat!("{dir}"),
	// 		format!("{dir}")
	// 	);
	// }
}

impl ChangeDirectory for Command {
	fn set_current_dir(&self, new_path: &Path) -> Option<PathBuf> {
		match std::env::set_current_dir(new_path) {
		    Ok(()) => Some(new_path.to_path_buf()),
		    Err(set_dir_error) => {
				self.verbose.cd_error(set_dir_error);
				None
			},
		}
	}

	fn previous_dir(&self) {

	}

	fn root(&self) -> Option<PathBuf> {
		self.set_current_dir(Path::new("/"))
	}

	fn specific_user_dir(&self, arg: String) {

	}

	fn home(&self) -> Option<PathBuf> {
		match home::home_dir() {
			Some(home_path_buf) => self.set_current_dir(&home_path_buf),
			None => self.root()
		}
	}

	fn cd_args(&self, vec_args: Vec<String>) -> Option<PathBuf> {
		let string_path = vec_args.concat();
		let new_path = Path::new(string_path.as_str());
		match new_path.is_dir() {
 			true => self.set_current_dir(new_path),
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
				_ => match arg.chars().next() {
					Some(char) => if char == '~' {todo!()} else {self.home()},
			        None => self.cd_args(vec_args),
				}
			},
			None => self.home()
		}
	}
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