function init()
  self.rotation = 0
  self.rotationRate = config.getParameter("rotationRate") or 20
  self.rotationRange = config.getParameter("rotationRange") or {-0.4, math.pi + 0.2}
  
  self.damage = {
    damage = 50,
    damageRepeatTimeout = 0.05,
    knockback = 50,
    sourceEntity = activeItem.ownerEntityId(),
    team = activeItem.ownerTeam(),
    raycheck = true,
  }
  
  local h = config.getParameter("damageConfig")
  if h then self.damage = sb.jsonMerge(self.damage, h) end
end

function update(dt, fireMode, shiftHeld)
  self.rotation = self.rotation + self.rotationRate * dt
  if self.rotation < self.rotationRange[1] or self.rotation > self.rotationRange[2] then
    self.rotationRate = -self.rotationRate
    self.rotation = self.rotation + self.rotationRate * dt * 2
  end
  
  local damageArea = animator.partPoly("hammer", "damageArea")
  if damageArea then
    for i,v in pairs(damageArea) do
      damageArea[i] = activeItem.handPosition(v)
    end
    self.damage.poly = damageArea
    activeItem.setDamageSources({self.damage})
  end
  
  activeItem.setArmAngle(self.rotation)
  activeItem.setFacingDirection(table.pack(activeItem.aimAngleAndDirection(-1, activeItem.ownerAimPosition()))[2])
end
