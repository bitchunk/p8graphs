## trifill()
Drawing filled triangles.
```
trifill(l, t, c, m, r, b, col)
```

- @param  number l    -- vertex -a- coordinate x.
- @param  number t    -- vertex -a- coordinate y.
- @param  number c    -- vertex -b- coordinate x.
- @param  number m    -- vertex -b- coordinate y.
- @param  number r    -- vertex -c- coordinate x.
- @param  number b    -- vertex -c- coordinate y.
- @param  number col  -- fill color.
- @description

## floodfill()
Determines and fills in the boundary color.
```
floodfill(x, y, p)
```
- @param  number x    -- coordinate x.
- @param  number y    -- coordinate y.
- @param  number col  -- fill & boundary color.
- @description

## segfill()
Fills filled segment shapes.
```
segfill(x, y, r, c, s, d)
```

- @param  number x  -- x coordinates.
- @param  number y  -- y coordinates.
- @param  number r  -- radius.
- @param  number c  -- fill color.
- @param  number s  -- starting angle, 0 is the bottom, 0.5 is the top.
- @param  number d  -- circumferential distance from start angle.
- @description
	- if the difference between the start angle and the end angle is 0.5 or more, it is a semicircle, and if the difference is 1 or more, it is a circle.
	- if the start position is higher than the end position, it is replaced.

## sectfill()
Fill filled sector shapes.
```
sectfill(x, y, r, c, s, d)
```
- @param  number x  -- x coordinates.
- @param  number y  -- y coordinates.
- @param  number r  -- radius.
- @param  number c  -- fill color.
- @param  number s  -- starting angle, 0 is the bottom, 0.5 is the top.
- @param  number d  -- circumferential distance from start angle.
- @description
	- if the difference between the start angle and the end angle is 0.5 or more, it is a semicircle, and if the difference is 1 or more, it is a circle.
	- if the start position is higher than the end position, it is replaced.
