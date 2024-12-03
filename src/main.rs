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
#[path = "./shell/verbose.rs"]
mod verbose;

fn main() {
	if let Some(args) = cli::parser() {
		let shell_config = shell::Config {
			norc: args.norc,
			verbose: args.verbose,
			extra_color: args.extra_color
		};
		let mut shell_instance = shell::LambdaShell::create(shell_config);
		shell_instance.start();
	};
}
