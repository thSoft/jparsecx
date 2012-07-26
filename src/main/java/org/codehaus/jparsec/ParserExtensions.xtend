package org.codehaus.jparsec

import java.util.List
import org.codehaus.jparsec.functors.Map
import org.eclipse.xtext.xbase.lib.IntegerRange

class ParserExtensions {

	def static Parser<?> operator_not(Parser<?> p) {
		p.not
	}

	def static <T> Parser<T> operator_doubleGreaterThan(Parser<?> p1, Parser<T> p2) {
		p1.next(p2)
	}

	def static <T> Parser<T> operator_doubleLessThan(Parser<T> p1, Parser<?> p2) {
		p1.followedBy(p2)
	}

	def static <T> Parser<T> operator_or(Parser<T> p1, Parser<? extends T> p2) {
		p1.or(p2)
	}

	def static <T> Parser<T> operator_mappedTo(Parser<?> p, T value) {
		p.retn(value)
	}

	def static <P, T> Parser<T> operator_mappedTo(Parser<P> p, Map<? super P, ? extends T> f) {
		p.map(f)
	}

	def static <T> Parser<List<T>> operator_times(Parser<T> p, int count) {
		p.repeat(count)
	}

	def static <T> Parser<List<T>> operator_times(Parser<T> p, IntegerRange range) {
		p.some(range.start, range.end)
	}

	def static <T> Parser<List<T>> operator_lessEqualsThan(Parser<T> p, int count) {
		p.some(count)
	}

	def static <T> Parser<List<T>> operator_greaterEqualsThan(Parser<T> p, int count) {
		p.many(count)
	}

}