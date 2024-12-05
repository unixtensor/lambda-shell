use liblambdashell::instance;

mod cli;

fn main() {
	if let Some(args) = cli::parser() {
		let shell_config = instance::Config {
			norc: args.norc,
		};
		let mut shell_instance = instance::LambdaShell::create(shell_config);
		shell_instance.start();
	};
}