mod cli;

fn main() {
	if let Some(args) = cli::parser() {
		let shell_config = liblambdashell::session::Config {
			norc: args.norc,
		};
		let mut shell_instance = liblambdashell::session::LambdaShell::create(shell_config);
		shell_instance.start();
	};
}