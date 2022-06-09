# Rust

## Books

* [Rust程序设计语言](https://rustwiki.org/zh-CN/book)
* [RustPrimer](https://rustcc.gitbooks.io/rustprimer)
* [Rust语言圣经](https://course.rs/about-book.html)
* [Rust入门秘籍](https://rust-book.junmajinlong.com/about.html)
* [The Rust Reference](https://doc.rust-lang.org/reference/introduction.html)
* [The Rustonomicon](https://doc.rust-lang.org/nightly/nomicon/intro.html)
* [rfcs](https://rust-lang.github.io/rfcs/introduction.html)
* [Asynchronous Programming in Rust](https://rust-lang.github.io/async-book/)
* [Rust in Action](https://livebook.manning.com/book/rust-in-action)
* [effective-rust](https://www.lurklurk.org/effective-rust/intro.html)

* [Rust API Guidelines](https://rust-lang.github.io/api-guidelines)
* [The Rust Performance Book](https://nnethercote.github.io/perf-book)

* https://github.com/rust-lang/rust
* https://github.com/rust-lang/futures-rs
* https://github.com/async-rs/async-std
* https://github.com/tokio-rs/tokio
* https://github.com/tokio-rs/axum
* https://github.com/rustwasm/wasm-bindgen
* https://github.com/bytecodealliance/wasmtime
* https://github.com/tikv/tikv
* https://os.phil-opp.com/allocator-designs

* [理解 Rust 中的生命周期](https://lotabout.me/2016/rust-lifetime/)
* [图解 Rust 所有权与生命周期](https://zhuanlan.zhihu.com/p/349644802)
* [Rust 闭包笔记](https://blog.linyinfeng.com/posts/how-do-rust-closures-work/)
* [rust {:p} 是打印被指向的pointer还是当前变量的pointer?](https://www.zhihu.com/question/311028043)
* [Rust 获取函数地址 裸指针](https://www.cnblogs.com/develon/p/15994912.html)
* [Rust 3.4 指针](https://lelouchhe.github.io/rust_3_4)
* [heap-stack](https://hardocs.com/d/rustprimer/heap-stack/heap-stack.html)
* [[译]Rust返回引用的不同策略](https://colobu.com/2019/08/13/strategies-for-returning-references-in-rust/)
* [为什么Rust的println!不会发生所有权转移？](https://zhuanlan.zhihu.com/p/261370020)
* [理解 Rust 引用和借用](https://zhuanlan.zhihu.com/p/59998584)
* [reborrowing-of-mutable-reference](https://stackoverflow.com/questions/65474162/reborrowing-of-mutable-reference)

## 堆栈

栈中的所有数据都必须占用已知且固定的大小，栈中的数据由编译器/操作系统分配内存，通过变量名来访问。
在编译时大小未知或大小可能变化的数据，要改为存储在堆上。堆是缺乏组织的。
堆内存的入口地址通常保存在栈上的一个变量中，可以通过这个变量来访问堆内存。

位于栈中的变量是相对静态的，可在编译期确定其生命周期，在运行期，伴随着入栈出栈而销毁。
对于堆上的数据，是动态的，可能会在运行期改变其生命周期，在编译期不能确定其生命周期。
如果能够将其生命周期与栈上的变量的生命周期绑定，则可以做到，随着栈上变量的自动清理，堆内存也随之自动清理。

所有权规则
首先，让我们看一下所有权的规则。当我们通过举例说明时，请谨记这些规则：

* Rust 中的每一个值都有一个被称为其 所有者（owner）的变量。
* 值在任一时刻有且只有一个所有者。
* 当所有者（变量）离开作用域，这个值将被丢弃。

## 变量

在Rust中，变量默认是不可改变的（`immutable`）。

```rs
fn main() {
    let x = 5;
    x = 6;
}
```

以上代码编译时会报出如下 `不能对不可变变量 x 二次赋值` 的错误。在其他编程语言中这可能很奇怪：变量不能改变，但是在 rust 中，却是正常的。

```rs
$ cargo build
   Compiling variables v0.1.0 (/Volumes/Data/Data/ws/knowledge/langs/rust/variables)
error[E0384]: cannot assign twice to immutable variable `x`
 --> src/main.rs:5:5
  |
3 |     let x = 5;
  |         - first assignment to `x`
4 |     println!("x = {}", x);
5 |     x = 6;
  |     ^^^^^ cannot assign twice to immutable variable

error: aborting due to previous error

For more information about this error, try `rustc --explain E0384`.
error: Could not compile `variables`.

To learn more, run the command again with --verbose.
```

那么，如何改变变量的值？

```rs
fn main() {
    let mut x = 5;
    println!("The value of x is: {}", x);
    x = 6;
    println!("The value of x is: {}", x);
}
```

以上代码，通过在变量前面 加 `mut` 关键字，向编译器同时也向开发人员表明该变量允许修改的。

常量（Constants）

```rs
const MAX_POINTS: u32 = 100_000;
```

虽然变量是不可变的，常量也是不能修改的，但是变量和常量还是有着本质上的不同。

变量默认是不可改变的，但是能够使其变成可以改变的，常量总是不可改变的，所以常量不能使用 `mut`。

遮蔽（Shadowing）

在 rust 中，变量可能会被同名的另一个变量遮蔽。

```rs
fn main() {
    let x = 5;

    let x = x + 1;

    let x = x * 2;

    println!("The value of x is: {}", x);
}
```

如上代码中，声明了 3 个不用的 `x`，这在很多语言中是不允许的。在 rust 中，后一变量遮住了前一个变量。

```rs
fn main() {
    let mut x = 5;

    x = x + 1;

    x = x * 2;

    println!("The value of x is: {}", x);
}
```

如果想使用同一个 变量 `x`，就需要声明 `x` 是 可改变的，如上。相比之前代码，这次只有一个变量 `x`，而前面的有 3 个 变量 `x`。

以上两种情况，编译器变对程序内存的布局是有显著的区别的。

## 类型

与变量紧密关联的就是数据类型，在 Rust 中，每个值都关联于某个数据类型。

数据类型绑定了一系列与类型相关的操作。

Rust 是 静态类型 语言，也就是说在编译时就必须知道所有变量的类型。编译器也具备类型推导功能，能够推导出变量的实际类型，所以很多时候类型可以省略。在某些情况下，比如可以推导出多种类型时，就需要类型注解。

我们将看到两类数据类型：标量（scalar）和复合（compound）。

标量类型：类型代表一个单独的值。Rust 中有四种基本的标量类型：`整型`、`浮点型`、`布尔类型`、`字符类型`。

  * 整数：
    * 有符号：i8 i16 i32 i64 iszize
    * 无符号：u8 u16 u32 i64 uszize

    字面值：

      Literal        | Example
      ---------------|---------------
      Decimal	       | 98_222
      Hex	           | 0xff
      Octal	         | 0o77
      Binary	       | 0b1111_0000
      Byte (u8 only) | b'A'

  * 浮点型：
    * 单精度：f32
    * 双精度：f64

  * 布尔型：
    * bool：true | false

  * 字符类型（char）：
    * char：'a' | 'z' | '😻'

复合类型：（Compound types）可以将多个值组合成一个类型。Rust 有两个原生的复合类型：元组（tuple）和数组（array）。

  * 元组类型：`(i32, f64, u8)`

    通过模式匹配解构元组：

    ```rs
    let _tup: (i32, f64, u8) = (500, 6.4, 1);

    let tup = (500, 6.4, 1);

    // 模式匹配 解构（destructuring）
    let (_x, y, _z) = tup;

    println!("The value of y is: {}", y);
    ```

    通过索引访问元组：

    ```rs
    let x: (i32, f64, u8) = (500, 6.4, 1);

    let _five_hundred = x.0;
    let _six_point_four = x.1;
    let _one = x.2;
    ```

  * 数组类型：`[]`

## 所有权

1. `Rust` 中的每一个值都有一个被称为其 所有者（`owner`）的变量。
2. 值有且只有一个所有者。
3. 当所有者（变量）离开作用域，这个值将被丢弃。

引用|借用（`borrowing`）：要原模原样的还，所以不能修改。

可变引用：允许借走之后修改。但是，在特定作用域中的特定数据有且只有一个可变引用。

从语言层面避免变量对同一内存数据的竞争。

数据竞争（data race）类似于竞态条件，它可由这三个行为造成：

* 两个或更多指针同时访问同一数据。
* 至少有一个指针被用来写入数据。
* 没有同步数据访问的机制。
