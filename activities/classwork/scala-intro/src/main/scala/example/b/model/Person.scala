package example.b.model

case class Person(firstName: String, lastName: String, gender: String) {


  def greeting(other: Person): String = other.gender match {
    case Person.Gender.male => s"Guten tag, herr ${other.lastName}"
    case Person.Gender.female => s"Guten tag, frau ${other.lastName}"
    case _ => "Guten tag!"
  }
}
object Person{
  object Gender{
    val male = "male"
    val female = "female"
    val undefined = "undefined"
  }
}



