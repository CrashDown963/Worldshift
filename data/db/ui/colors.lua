colors = {
  black = { 0, 0, 0 },
  white = { 255, 255, 255 },
  red = { 255, 0, 0 },
  green = { 0, 255, 0 },
  blue = { 0, 0, 255 },
  yellow = { 255, 255, 0 },
  magenta = { 255, 0, 255 },
  --
  requ_met = { 0, 255, 0 },
  requ_notmet = { 255, 0, 0 },
  --
  nomana = { 128, 128, 255 },
  --
  GetStr = function(colorName) return colors[colorName][1] .. "," .. colors[colorName][2] .. "," .. colors[colorName][3] end
}

ItemColors = {
	q1 = { 183,187,200 }, -- quality
	q2 = { 119,224,80 },
	q3 = { 255,255,0 },
	q4 = { 255,172,49 },
	q5 = { 204,0,204 },
	q6 = { 255, 0, 0 },

	h1 = { 183,187,200 }, -- highlight
	h2 = { 119,224,80 },
	h3 = { 255,255,0 },
	h4 = { 255,172,49 },
	h5 = { 130,5,177 },
	h6 = { 255, 0, 0 },

-- obsolete

	q7 = { 248,177,7 },
-- 	
	dragged = { 212,192,70 },
}

AlienItemColors = {
  red = { 255,0,0 },
  green = { 0,255,0 },
  blue = { 0,0,255 },
  yellow = { 255,255,0 },
  inactive = { 30,30,30 },
}

HumanItemColors = {
  red = { 255,0,0 },
  green = { 0,255,0 },
  blue = { 0,0,255 },
  yellow = { 255,255,0 },
  cyan = { 0,255,255 },
  magenta = { 255,0,255 },
  inactive = { 30,30,30 },
}

MutantItemColors = {
  red = { 255,0,0 },
  green = { 0,255,0 },
  blue = { 0,0,255 },
  yellow = { 255,255,0 },
  cyan = { 0,255,255 },
  magenta = { 255,0,255 },
  inactive = { 30,30,30 },
}

ProgressColors = {
	power_stoped = { 
		left  = { 204, 0, 0, 255 },
		right = { 0, 0, 102, 255 },
		back  = { 77, 77, 0, 25 },
	},
	power = { 
		left  = { 35, 150, 250, 255 },
		right = { 0, 0, 102, 255 },
		back  = { 0, 0, 77, 25 },
	},
	shield_down = { 
		left  = { 127, 108, 0, 255 },
		right = { 123, 77, 0, 255 },
		back  = { 77, 77, 0, 25 },
	},
	shield = { 
		left  = { 255, 216, 0, 255 },
		right = { 245, 134, 0, 255 },
		back  = { 77, 77, 0, 25 },
	},
	health = { 
		left  = { 0, 204, 0, 255 },
		right = { 204, 0, 0, 255 },
		back  = { 77, 77, 0, 25 },
	},
	health_enemy = { 
		left  = { 0, 204, 204, 255 },
		right = { 0, 102, 102, 255 },
		back  = { 77, 77, 0, 25 },
	},
	upgrade = { 
		left  = { 255, 216, 0, 255 },
		right = { 245, 134, 0, 255 },
		back  = { 77, 77, 0, 25 },
	},
	pickitem = { 
		left  = { 255, 216, 0, 255 },
		right = { 245, 134, 0, 255 },
		back  = { 77, 77, 0, 25 },
	},
	capture = { 
		left  = { 255, 216, 0, 255 },
		right = { 245, 134, 0, 255 },
		back  = { 77, 77, 0, 25 },
	},
	construct = { 
		left  = { 255, 216, 0, 255 },
		right = { 245, 134, 0, 255 },
		back  = { 77, 77, 0, 25 },
	},
	
}

PlayerColors = {
  { 255, 0, 0 },
  { 150, 0, 0},
  { 48, 203, 0 },
  { 255, 255, 0 },
  { 255, 165, 0 },
  { 16, 76, 254 },
  { 0, 0, 139 },  
  { 175,0,225 },
  { 0, 255, 200 },
  { 255, 106, 183 },
  { 180, 255, 100 },
  { 126, 141, 0 },
  { 100, 30, 5 },
  { 150, 75, 0 },
  { 255, 255, 255 },
  { 0, 0, 0 },
  }
