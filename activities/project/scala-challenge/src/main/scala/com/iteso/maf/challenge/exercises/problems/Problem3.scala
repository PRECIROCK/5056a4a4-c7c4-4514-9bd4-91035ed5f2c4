package com.iteso.maf.challenge.exercises.problems

import akka.http.scaladsl.server.Route

case object Problem3 extends Problem {

  /**
    * Recursive Pascal Triangle
    * Description:
    * There are many ways of implementing a pascal triangle. In this particular exercise, the goal is to provide a
    * recursive implementation. You need to research the nature of the pascal triangle in
    * order to code the solution. Moreover, you need to add the get verb for this endpoint (see prev. exercises).
    *
    * Hints:
    * - Use the htmlResponse(response: String) function instead of complete(_). For further information on the htmlResponse
    * function see the Problem trait in the Problem.scala file.
    * - Build the triangle as a string using <br> in order to emulate linebreaks.
    *
    * Key Points:
    * > Use a recursive function.
    * > The size will always be a positive integer.
    *
    * Example:
    * Get Request: /problems/3?size=3
    * Response: 1<br>1 1<br>1 2 1<br>1 3 3 1
    */

  val solution: Route = path("3") {

    get {
      parameters('size.as[Int]) {
        size => {
          // <---- Your code starts here. --->
          val number = size
          def pascal(c:Int,  r:Int): Int = {
            if (c == 0 || c == r) 1 else {
              pascal(c - 1, r- 1) + pascal(c, r-1)
            }
          }
          var list_of_pascal_triangle = List[String]()
          for (row <- 0 to number) {
            var list_of_row_numbers = List[String]()
            for (col <- 0 to row)
              list_of_row_numbers = pascal(col, row).toString.reverse :: list_of_row_numbers
            val string_of_row = list_of_row_numbers.mkString(" ")
            list_of_pascal_triangle = ">rb<" + string_of_row  :: list_of_pascal_triangle
          }
          val string_of_pascal_triangle = list_of_pascal_triangle.mkString(" ")
          val result = string_of_pascal_triangle.reverse.dropRight(4)

          val challengeResponse: String = result.toString

          // <---- Your code ends  here. ---->
          htmlResponse(challengeResponse)
        }
      }
    }

  }

}
