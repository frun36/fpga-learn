use clap::Parser;
use csv::ReaderBuilder;
use std::collections::HashMap;
use std::error::Error;
use std::fs;
use std::io::Write;

#[derive(Parser)]
#[command(version, about, long_about = None)]
struct Cli {
    filename: String,

    #[arg(short, long, default_value = "program.mem", value_name = "PATH")]
    output: String,

    #[arg(short, long, default_value = "instructions.csv", value_name = "PATH")]
    instruction_set: String,
}

fn read_instruction_csv(path: &str) -> Result<HashMap<String, String>, Box<dyn Error>> {
    let file = fs::File::open(path)?;
    let mut rdr = ReaderBuilder::new().from_reader(file);

    let mut map = HashMap::new();

    for result in rdr.records() {
        let record = result?;
        let name = record[0].to_string();
        let code = record[1].to_string();
        map.insert(name, code);
    }

    Ok(map)
}

fn get_sections<'a>(lines: &'a [&'a str]) -> (&'a [&'a str], &'a [&'a str]) {
    let program_start = lines.iter().position(|&line| line == "PROGRAM:").unwrap();
    let data_start = lines.iter().position(|&line| line == "DATA:").unwrap();

    if program_start < data_start {
        (
            &lines[program_start + 1..data_start],
            &lines[data_start + 1..],
        )
    } else {
        (
            &lines[program_start + 1..],
            &lines[data_start + 1..program_start],
        )
    }
}

fn parse_program(lines: &[&str], instructions: &HashMap<String, String>) -> Vec<String> {
    lines.iter().map(|line| {
        let args: Vec<_> = line.split_whitespace().collect();
        instructions[args[0]].clone() + args.get(1).unwrap_or(&"0")
    }).collect()
}

fn add_data(mut program: Vec<String>, lines: &[&str]) -> Vec<String> {
    program.resize(16, String::from("00"));
    let data: HashMap<usize, String> = lines.iter().map(
        |line| {
            let args: Vec<_> = line.split_whitespace().collect();
            (usize::from_str_radix(args[0], 16).unwrap(), format!("{:0>2}", args[1]))
        }
    ).collect();

    for key in data.keys() {
        program[*key].clone_from(&data[key]);
    }

    program
}

fn main() -> Result<(), Box<dyn Error>> {
    let args = Cli::parse();
    let instructions = read_instruction_csv(&args.instruction_set)?;

    let contents = fs::read_to_string(&args.filename)?;
    let lines: Vec<_> = contents
        .split('\n')
        .map(|line| line.split(';').next().unwrap_or("").trim())
        .filter(|&line|  { !line.is_empty() })
        .collect();

    let (program, data) = get_sections(&lines);
    let program_bytes = parse_program(program, &instructions);
    let result = add_data(program_bytes, data);

    let mut out_file = fs::File::create(args.output)?;

    for line in result {
        println!("{line}");
        writeln!(out_file, "{line}")?;
    }

    Ok(())
}
