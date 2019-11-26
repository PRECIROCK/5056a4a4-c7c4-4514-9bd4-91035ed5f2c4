package example.c

import example.c.model.Box

object Main {

  val numbers: List[Int]= List(1,2,3,4,5)

  def procedure(args: Array[Int]): Box[Int]   =
    args.map(num => Box(num)).foldRight(Box(0)) {
      case (elm, z) => z.concat(elm).map(_.toInt)
    }

  // valid case: sbt "runMain example.c.Main 1 2 3 4 5"
  // invalid case: sbt "runMain example.c.Main"
  def main(args: Array[String]): Unit = args match {
    case valid if args.length > 0 => procedure(args.map(_.toInt)).show()
    case _ => println("""Invalid argument.""")
  }
}
