package example.d.model

import example.a.model.Timestamp

trait Visitor {
  def id: String
  def createdAt: Timestamp

  def getAge: Int = createdAt.seconds

  def show(): Unit = this match {
    case Visitor.Anonymous(id,_) =>
      println(s"Anonymous user with id$id")
    case Visitor.User(_, email, _) =>
      println(s"User with email $email")
  }

  def getEmail: Option[String]
}

object Visitor {
  final case class Anonymous(id: String, createdAt: Timestamp) extends Visitor {
    override def getEmail: Option[String] = None
  }
  final case class User(id: String, email: String, createdAt: Timestamp) extends Visitor {
    override def getEmail: Option[String] = Some(email)
  }

}
