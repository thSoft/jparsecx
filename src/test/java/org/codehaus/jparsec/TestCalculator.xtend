package org.codehaus.jparsec

import org.codehaus.jparsec.functors.Map
import org.codehaus.jparsec.functors.Map2
import org.junit.Test

import static junit.framework.Assert.*
import static org.codehaus.jparsec.Parser.*
import static org.codehaus.jparsec.Scanners.*
import static org.codehaus.jparsec.TestCalculator.*

import static extension org.codehaus.jparsec.ParserExtensions.*

class TestCalculator {

	static val NUMBER = INTEGER.map[String it | Integer::valueOf(it)]

	static val Map2<Integer, Integer, Integer> PLUS = [a, b | a + b]

	static val Map2<Integer, Integer, Integer> MINUS = [a, b | a - b]

	static val Map2<Integer, Integer, Integer> MUL = [a, b | a * b]

	static val Map2<Integer, Integer, Integer> DIV = [a, b | a / b]

	static val Map2<Integer, Integer, Integer> MOD = [a, b | a % b]

	static val Map<Integer, Integer> NEG = [-it]

	def static <T> op(String ch, T value) {
		isChar(ch) -> value
	}

	def static isChar(String ch) {
		isChar(ch.charAt(0))
	}

	def static Parser<Integer> parser() {
		val ref = <Integer>newReference
		val term = (isChar('(') >> ref.lazy << isChar(')')) || NUMBER
		val parser = new OperatorTable<Integer>
				.prefix(op('-', NEG), 100)
				.infixl(op('+', PLUS), 10)
				.infixl(op('-', MINUS), 10)
				.infixl(op('*', MUL), 20)
				.infixl(op('/', DIV), 20)
				.infixl(op('%', MOD), 20)
				.build(term)
		ref.set(parser)
		parser
	}

	def static int evaluate(String source) {
		parser.parse(source)
	}

	def void assertResult(int expected, String source) {
		assertEquals(expected, evaluate(source))
	}

	@Test def void testEvaluate() {
		assertResult(1, "1")
		assertResult((1), "(1)")
		assertResult(1+2, "1+2")
		assertResult(1+2*-3, "1+2*-3")
		assertResult(((1-2)/-1), "((1-2)/-1)")
	}

}
