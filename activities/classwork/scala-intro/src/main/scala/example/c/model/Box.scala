package example.c.model

case class Box[A](value: A) {

  def show(): Unit = println(value)

  def map[B](f: A => B): Box[B] = Box(f(value))

  def flatMap(f: A => Box[A]): Box[A] = f(value)

  def concat(other: Box[A]): Box[String] =
    Box(value.toString + other.value.toString)

}
