/*
 * Copyright (c) 2013 Christopher Atherton. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

module util.crc32;

struct Crc32( uint Poly = 0x04C11DB7, bool Reversed = false )
{
	void crunch( in ubyte[] data )
	{
		static if( Reversed )
		{
			foreach( i; data )
				_sum = TAB[ ( _sum ^ i ) & 0xFF ] ^ ( _sum >> 8 );
		}
		else
		{
			foreach( i; data )
				_sum = TAB[ ( _sum >> 24 ) ^ i ] ^ ( _sum << 8 );
		}
	}

	@property uint sum()
	{
		static if( Reversed )
			return ~_sum;
		else
			return _sum;
	}

	private
	{
		static immutable uint[256] TAB = computeTable();

		static if( Reversed )
			uint _sum = 0xFFFFFFFF;
		else
			uint _sum;
	}

	private static uint[256] computeTable() pure
	{
		uint[256] ret;

		static if( Reversed )
		{
			foreach( uint i, ref uint u; ret )
			{
				u = i;
				foreach( j; 0 .. 8 )
				{
					if( u & 1 )
						u = ( u >> 1 ) ^ Poly;
					else
						u = ( u >> 1 );
				}
			}
		}
		else
		{
			foreach( uint i, ref uint u; ret )
			{
				u = i << 24;
				foreach( j; 0 .. 8 )
				{
					if( u & 0x80000000 )
						u = ( u << 1 ) ^ Poly;
					else
						u = ( u << 1 );
				}
			}
		}

		return ret;
	}
}
