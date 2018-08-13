---
description: Tooling your application with failure libraries allows for deeper chaos.
---

# Failure as a Feature

Sometimes just creating failures at random, or introducing fuzziness external to the executable in question isn't quite enough.

Perhaps you suspect your system may be susceptible to failures during one particular part of code, or you'd like to reliably cause a failure in one component, and introduce fuzziness to another.

One tactic for doing this is to use "Fail points."

## What's a Fail Point?

A fail point is a configurable defined marker in your code.

You can find fail point libraries for some common programming languages.

* [https://github.com/pingcap/fail-rs](https://github.com/pingcap/fail-rs)
* [https://github.com/etcd-io/gofail](https://github.com/etcd-io/gofail)

What does a fail point look like?

```rust
fn example_function() {
    println!("I hope I don't fail...");
    fail_point!("here");
    println!("Whew, I survived!");
}
```

Or inject an error \(or something else\), instead of a panic:

```rust
fn get(&self, key: &Key) -> Result<Value> {
    fail_point!("get_fails_with_error", |_| Err(box_err!(
        "injected error for get"
    )));
    // ...
}
```

Running it:

```bash
FAILPOINTS="here=panic" cargo run
# I hope I don't fail...
# thread 'main' panicked at 'failpoint here panic', /home/hoverbear/.cargo/registry/src/github.com-1ecc6299db9ec823/fail-0.2.0/src/lib.rs:286:25
# note: Run with `RUST_BACKTRACE=1` for a backtrace.
```

## Where to Place Fail Points

You can use fail points to simulate simple failures, such as a write failure:

```rust
impl<S: RaftStoreRouter> Engine for RaftKv<S> {
    type Iter = RegionIterator;
    type Snap = RegionSnapshot;

    fn async_write(
        &self,
        ctx: &Context,
        modifies: Vec<Modify>,
        cb: Callback<()>,
    ) -> engine::Result<()> {
        fail_point!("raftkv_async_write");
        // ...
```

Placing failures at critical sections of your code can allow you to, for example, cause a panic after getting a snapshot sent from a peer:

```rust
/// Event handler for the completion of get snapshot.
///
/// Delivers the command along with the snapshot to a worker thread to execute.
fn on_snapshot_finished(
    // ...
) {
    fail_point!("scheduler_async_snapshot_finish");
    // ...
```

Or failure during an iterator:

```rust
impl Snapshot for RegionSnapshot {
    type Iter = RegionIterator;

    // ...
    fn iter(&self, iter_opt: IterOption, mode: ScanMode) -> engine::Result<Cursor<Self::Iter>> {
        fail_point!("raftkv_snapshot_iter", |_| Err(box_err!(
            "injected error for iter"
        )));
        Ok(Cursor::new(RegionSnapshot::iter(self, iter_opt), mode))
    }
    
    // ...
```



