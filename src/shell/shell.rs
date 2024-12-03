use super::{commands, verbose::Verbose};
use color_print::cformat;
use std::io;
use super::ps;

pub struct Config {
	pub norc: bool,
	pub verbose: bool,
	pub extra_color: bool
}
pub struct Storage {
	pub command_exit_status: commands::ProcessExitStatus,
	pub ps1: String
}
pub struct LambdaShell {
	terminating: bool,
	storage: Storage,
	verbose: Verbose,
	config: Config
}

trait Color {
	fn error(&self, error_name: &str, error: &io::Error);
}
impl Color for Verbose {
	#[inline]
	fn error(&self, error_name: &str, error: &io::Error) {
		self.format(
			cformat!("<r>{error_name} error:</> <bold>{error}</>"),
			cformat!("{error_name} error: {error}"),
		)
	}
}

impl LambdaShell {
	pub fn create(config: Config) -> Self {
		Self {
			storage: Storage {
				command_exit_status: None,
				ps1: ps::DEFAULT_PS.to_string(),
			},
			verbose: Verbose::new(config.verbose, config.extra_color),
			terminating: false,
			config,
		}
	}

	fn input(&mut self) {
		let mut input = String::new();
		match io::stdin().read_line(&mut input) {
   			Ok(_size) => {
				let trimmed_input = input.trim();
				match trimmed_input {
					//special casey
					"exit" => self.terminating = true,
					_ => self.storage.command_exit_status = commands::Command::new(trimmed_input.to_string(), self.verbose).exec(),
				};
			},
    		Err(read_error) => self.verbose.error("Read", &read_error),
		};
	}

	pub fn wait(&mut self) -> Result<(), io::Error> {
		match io::Write::flush(&mut io::stdout()) {
		    Ok(()) => {
				self.input();
				Ok(())
			},
		    Err(flush_error) => {
				self.verbose.error("Flush", &flush_error);
				Err(flush_error)
			},
		}
	}

	pub fn start(&mut self) {
		if self.config.verbose {
			color_print::cprintln!("<bold>Verbose mode enabled.</>")
		}

		loop {
			match self.terminating {
				true => break,
				false => {
					ps::display(&mut self.storage);
					if let Err(flush_error) = self.wait() {

						break
					};
				}
			}
		}
	}
}