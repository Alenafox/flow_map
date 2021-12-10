FlowMap = {}
FlowMap.__index = FlowMap

function FlowMap:create (size)
    local map = {}
    setmetatable(map, FlowMap)
    map.field = {}
    map.size = size
    love.math.setRandomSeed(10000)
    return map
end 

function FlowMap:init()
	local cols = width/self.size
	local rows = height/self.size

    local xoff = 0
	local x = math.floor(cols/2)
	local y = math.floor(rows/2)
	local yoff = 0


	for i = 1, cols do
        yoff = 0
		self.field[i] = {}
		for j = 1, rows do
            local thetaX = 0.2 + x-i
			local thetaY = 0.2 + y-j
			local X = 1
            local theta = 1
            if thetaX ~= 0 then
                theta = math.abs(thetaX)/thetaX
                X = theta*(thetaY)/thetaX
                if math.abs(X) > 1 then
                    theta = theta/math.abs(X)
                    X = math.abs(X)/X
                end
            elseif thetaY ~= 0 then
                X = math.abs(thetaY)/thetaY
            end
            self.field[i][j] = Vector:create(X, -theta)
        end
        xoff = xoff + 0.1
    end
end

function FlowMap:lookup(v)
	local col = math.constrain(math.floor(v.x/self.size)+1, 1, #self.field)
	local row = math.constrain(math.floor(v.y/self.size)+1, 1, #self.field[1])
	return self.field[col][row]:copy()
end

function FlowMap:draw()
	for i = 1, #self.field do
		for j = 1, #self.field[1] do
			drawVector(self.field[i][j], (i-0.5) * self.size, (j-0.5) * self.size, self.size-2)
		end
	end
end

function drawVector(v, x, y, s)
	love.graphics.push()
	love.graphics.translate(x,y)
	love.graphics.rotate(v:heading())
	local len = v:mag() * s
	love.graphics.line(0,0,len,0)
	love.graphics.circle("fill",len,0,2)
	love.graphics.pop()
end