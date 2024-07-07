pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--trifill v0.5
--@shiftalow / bitchunk

--[[
	- trifill        			  -- fill in the triangle.
	- @param  number l    -- vertex -a- coordinate x.
	- @param  number t    -- vertex -a- coordinate y.
	- @param  number c    -- vertex -b- coordinate x.
	- @param  number m    -- vertex -b- coordinate y.
	- @param  number r    -- vertex -c- coordinate x.
	- @param  number b    -- vertex -c- coordinate x.
	- @param  number col  -- vertex -c- coordinate x.
	- @description
		-- 
]]--

--pelogen_tri_hvbaf
function trifill(l,t,c,m,r,b,col)
	color(col)
	local a=rectfill
	::_w_::
 if(t>m)l,t,c,m=c,m,l,t
 if(m>b)c,m,r,b=r,b,c,m
 if(t>m)l,t,c,m=c,m,l,t

	local q,p=l,c
	if (q<c) q=c
	if (q<r) q=r
	if (p>l) p=l
	if (p>r) p=r
	if b-t>q-p then
		l,t,c,m,r,b,col=t,l,m,c,b,r
		goto _w_
	end

	local e,j,i=l,(r-l)/(b-t)
	while m do
		i=(c-l)/(m-t)
		local f=(m&0xffff)-1
		f=f>127 and 127 or f
		if(t<0)t,l,e=0,l-i*t,b and e-j*t or e
		if col then
			for t=t&0xffff,f do
				a(l,t,e,t)
				l=i+l
				e=j+e
			end
		else
			for t=t&0xffff,f do
				a(t,l,t,e)
				l=i+l
				e=j+e
			end
		end
		l,t,m,c,b=c,m,b,r
	end
	if i<8 and i>-8 then
		if col then
			pset(r,t)
		else
			pset(t,r)
		end
	end
end
-->8
--[[
update history
**v0.5**
	- split into fastest, intermediate, and smallest versions.

.
.
.

**v0.1**
	- first release
]]--

--140(top clipping)
--function pelogen_tri_tclip(l,t,c,m,r,b,col)
--	color(col)
--	local a=rectfill
--	while t>m or m>b do
--		l,t,c,m=c,m,l,t
--		while m>b do
--			c,m,r,b=r,b,c,m
--		end
--	end
--	local e,j=l,(r-l)/(b-t)
--	while m do
--		local i=(c-l)/(m-t)
--		if(t<0)t,l,e=0,l-i*t,b and e-j*t or e
--		for t=flr(t),min(flr(m)-1,127) do
--			a(l,t,e,t)
--			l+=i
--			e+=j
--		end
--		l,t,m,c,b=c,m,b,r
--	end
--	pset(r,t)
--end

--113
--function pelogen_tri_low(l,t,c,m,r,b,col)
--	color(col)
--	while t>m or m>b do
--		l,t,c,m=c,m,l,t
--		while m>b do
--			c,m,r,b=r,b,c,m
--		end
--	end
--	local e,j=l,(r-l)/(b-t)
--	while m do
--		local i=(c-l)/(m-t)
--		for t=flr(t),min(flr(m)-1,127) do
--			rectfill(l,t,e,t)
--			l+=i
--			e+=j
--		end
--		l,t,m,c,b=c,m,b,r
--	end
--	pset(r,t)
--end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
