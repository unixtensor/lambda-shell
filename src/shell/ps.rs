use color_print::{cformat, cprint};
use const_format::formatcp;
use super::shell;

pub const DEFAULT_PS: &str = formatcp!("{}-{}", env!("CARGO_PKG_NAME"), env!("CARGO_PKG_VERSION"));

pub fn working_dir_name() -> String {
	match &std::env::current_dir() {
		Ok(pathbuf) => match pathbuf.file_name() {
		    Some(name) => match name.to_os_string() == whoami::username_os() {
		        true => "~".to_string(),
		        false => name.to_string_lossy().to_string(),
		    },
		    None => "?".to_string(),
		},
	    Err(_) => "?".to_string(),
	}
}

pub fn display(shell_storage: &mut shell::Storage) {
	// let exit_status = shell_storage.command_exit_status.map(|s| format!(" [{s}] ")).unwrap_or(" ".to_string());
	let working_dir_name = cformat!(" <bold>{}</> ", working_dir_name());

	cprint!("{}{}λ ", shell_storage.ps1, working_dir_name);
}