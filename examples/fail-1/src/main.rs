#[macro_use(fail_point)]
extern crate fail;

fn example_function() {
    println!("I hope I don't fail...");
    fail_point!("here");
    println!("Whew, I survived!");
}

fn main() {
    fail::setup();
    // ...
    example_function();
    // ...
    fail::teardown();
}

#[test]
fn test_example_function() {
    fail::setup();
    // Enable the failure.
    fail::cfg("here", "panic")
        .unwrap();
    example_function();

    fail::teardown();
}
