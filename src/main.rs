#[path = "./shell/shell.rs"]
mod shell;
#[path = "./shell/ps.rs"]
mod ps;
#[path = "./shell/rc.rs"]
mod rc;
#[path = "./shell/commands.rs"]
mod commands;
#[path = "./shell/cli.rs"]
mod cli;

fn main() {
	if let Some(args) = cli::parser() {
		let shell_config = shell::Config {
			norc: args.norc,
		};
		let mut shell_instance = shell::LambdaShell::create(shell_config);
		shell_instance.start();
	};
}
