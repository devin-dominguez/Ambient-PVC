--[[
  Hole position calculator for rim blown flute
  Devin Dominguez 2012
--]]

-- MEASUREMENTS AND OTHER VARIABLES

--[[
f = fundamental frequency (hz)
  - A  440.00Hz
  - G  392.00Hz
  - F  349.23Hz
  - E  329.63Hz
  - D  293.67Hz
  - C  261.63HZ
  - Bb 233.08Hz
--]]
f = 261.63

--[[
scale = Scale intervals above the fundamental (decimal or fractional ratios)
      - 12tET 'Ney': 1.22462, 1.189207, 1.259921, 1.334840, 1.414214, 1.498307, 1.681793
	  - Just 'Ney': 9/8, 153/128, 81/64, 4/3, 45/32, 3/2, 27/16
      - Pythagorean Minor Pentatonic: 32/27, 4/3, 3/2, 16/9, 2/1
--]]
scale = {9/8, 153/128, 81/64, 4/3, 45/32, 3/2, 51/32}

-- length of pipe (mm)
L0 = 610

--[[
a = Internal radius of pipe (mm)
  - 1/2" schedule 40 PVC:  7.8994 mm
  - 3/4" schedule 40 PVC: 10.4648 mm
--]]
a = 7.8994

--[[
t = thickness of pipe walls (mm)
  - 1/2" schedule 40 PVC: 2.7686 mm
  - 3/4" schedule 40 PVC: 2.8702 mm
--]]
t = 2.7686

--[[
b = radius of finger holes (mm)
	BIT       RADIUS
  - 19/64" -> 3.7703 mm
  -  5/16 " -> 3.9688 mm
  - 21/64" -> 4.1675 mm
  - 11/32" -> 4.3656 mm
  - 23/64" -> 4.5641 mm
  -  3/8 " -> 4.7625 mm
  - 25/64" -> 4.9609 mm
  - 13/32" -> 5.1594 mm
--]]
b = 3.969

-- number of times to refine hole positions (not really necessary to edit unless something goes wrong)
reps = 30


-- CALCULATIONS

-- calculate effective length based on fundamental
Le0 = (345000/f)/2
-- calculate blowing end length correction
Lb = Le0-L0-.6*a


-- calculate initial hole positions
Le = {}
L = {}
for i = 1, #scale do
  Le[i] = scale[i]^-1*Le0
  L[i] = Le[i]-Lb-.6*a
end


-- refine position of hole 1
for r = 1, reps do
  D = L0-L[1]
  Lc = (t+1.5*b)/((b/a)^2+(t+1.5*b)/D)
  L[1] = Le[1]-Lb-Lc
end


-- refine positions of remaining holes
for i = 2, #scale do
  for r = 1, reps do
    s = (L[i-1] - L[i])/2
    Lc =  s*( (1+2*(1.5*b+t)*(a/b)^2 /s)^.5 -1)
    L[i] = Le[i]-Lb-Lc
  end
end


-- print results
for i = 1, #scale do
  print("Hole " .. i .. ": " ..L0-L[i] .. " | Ratio " .. i .. ": " .. (L0-L[i])/L0)
end
