use liblambdashell::shell;

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