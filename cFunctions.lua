--[[
///////////////////
(c) 2020-2021
by Lorenzo(DORTEY)
///////////////////
]]


local Settings={
	DisabledHudComponents={
		"ammo",
		"armour",
		"clock",
		"health",
		"money",
		"weapon",
		"wanted",
		"breath",
	},
	
	smoothMoveArmor=0,
	smoothMoveHealth=0,
	smoothMoveMoney=0,
}

GLOBALscreenX,GLOBALscreenY=guiGetScreenSize()
Gsx=GLOBALscreenX/1920
Gsy=GLOBALscreenY/1080

local ResourcePhad=getResourceName(getThisResource());
addEventHandler("onClientRender",root,function()
	--//Disable Standart GTASA huds
	for i=1,#Settings.DisabledHudComponents do
		setPlayerHudComponentVisible(Settings.DisabledHudComponents[i],false)
	end
	
	
	if(not(isPedDead(localPlayer)))then
		local time=getRealTime()
		local hour=time.hour
		local minute=time.minute
		local second=time.second
		local day=time.monthday
		local month=time.month+1
		local year=time.year+1900
		if(hour<10)then
			hour="0"..hour
		end
		if(minute<10)then
			minute="0"..minute
		end
		if(second<10)then
			second="0"..second
		end
		if(day<10)then
			day="0"..day
		end
		if(month<10)then
			month="0"..month
		end
		
		local armor=math.floor(getPedArmor(localPlayer))or 0;
		local health=math.floor(getElementHealth(localPlayer))or 0;
		local oxygen=getPedOxygenLevel(localPlayer);
		local money=getPlayerMoney(localPlayer);
		
		local armorAmount=240/100*armor;
		local healthAmount=240/100*health;
		
		dxDrawRectangle(1780*Gsx,10*Gsy,130*Gsx,100*Gsy,tocolor(0,0,0,170),false)--Skin Background
		dxDrawImage(1780*Gsx,5*Gsy,125*Gsx,105*Gsy,":"..ResourcePhad.."/Files/Skins/"..tonumber(getElementModel(localPlayer))..".png",0.0,0.0,0.0,tocolor(255,255,255,255),false)--Skin Image
		
		dxDrawRectangle(1635*Gsx,10*Gsy,140*Gsx,48*Gsy,tocolor(0,0,0,170),false)--Date Background
		dxDrawRectangle(1635*Gsx,62*Gsy,140*Gsx,48*Gsy,tocolor(0,0,0,170),false)--Time Background
		dxDrawText(day.."."..month.."."..year,1820*Gsx,23*Gsy,1588*Gsx,30*Gsy,tocolor(255,255,225,255),1.60*Gsx,"default-bold","center",_,_,_,false,_,_)--Date Text
		dxDrawText(hour..":"..minute..":"..second,1820*Gsx,70*Gsy,1588*Gsx,30*Gsy,tocolor(255,255,225,255),2.0*Gsx,"default-bold","center",_,_,_,false,_,_)--Time Text
		
		--//Render Bars
		if(Settings.smoothMoveArmor>armorAmount)then
			Settings.smoothMoveArmor=Settings.smoothMoveArmor-1;
		end
		if(Settings.smoothMoveArmor<armorAmount)then
			Settings.smoothMoveArmor=Settings.smoothMoveArmor+1;
		end
		if(Settings.smoothMoveHealth>healthAmount)then
			Settings.smoothMoveHealth=Settings.smoothMoveHealth-1
		end
		if(Settings.smoothMoveHealth<healthAmount)then
			Settings.smoothMoveHealth=Settings.smoothMoveHealth+1
		end
		if(money~=Settings.smoothMoveMoney)then
			if(money<Settings.smoothMoveMoney)then
				local diff=Settings.smoothMoveMoney-money
				local rem=math.ceil(diff/150)
				Settings.smoothMoveMoney=Settings.smoothMoveMoney-rem
			else
				local diff=money-Settings.smoothMoveMoney
				local rem=math.ceil(diff/150)
				Settings.smoothMoveMoney=Settings.smoothMoveMoney+rem
			end
		end
		
		
		--Armor & Oxygen
		dxDrawRectangle(1635*Gsx,117*Gsy,280*Gsx,33*Gsy,tocolor(0,0,0,170),false)--Background
		if(isElementInWater(localPlayer))then
			dxDrawRectangle(1670*Gsx,120*Gsy,240*Gsx,27.5*Gsy,tocolor(0,120,120,255),false)
			dxDrawRectangle(1670*Gsx,120*Gsy,240/1751*oxygen*Gsx,13.5*Gsy,tocolor(0,180,180,255),false)
			dxDrawRectangle(1670*Gsx,133.5*Gsy,240/1751*oxygen*Gsx,13.5*Gsy,tocolor(0,220,220,255),false)
			dxDrawImage(1640*Gsx,120*Gsy,25*Gsx,25*Gsy,":"..ResourcePhad.."/Files/Oxygen.png",0,0,0,tocolor(255,255,255,255),false)
			dxDrawText(math.floor(oxygen/10).."%",1990*Gsx,123*Gsy,1588*Gsx,30*Gsy,tocolor(255,255,225,255),1.40*Gsx,"default-bold","center",_,_,_,false,_,_)
			--[[
			INFO: You need a oxygen skill to get the bar full    (then you have more than 100%)
			]]
		else
			dxDrawRectangle(1670*Gsx,120*Gsy,240*Gsx,27.5*Gsy,tocolor(120,120,120,255),false)
			dxDrawRectangle(1670*Gsx,120*Gsy,Settings.smoothMoveArmor*Gsx,13.5*Gsy,tocolor(160,160,160,255),false)
			dxDrawRectangle(1670*Gsx,133.5*Gsy,Settings.smoothMoveArmor*Gsx,13.5*Gsy,tocolor(200,200,200,255),false)
			dxDrawImage(1640*Gsx,120*Gsy,26*Gsx,26*Gsy,":"..ResourcePhad.."/Files/Armor.png",0,0,0,tocolor(255,255,255,255),false)
			dxDrawText(armor.."%",1990*Gsx,123*Gsy,1588*Gsx,30*Gsy,tocolor(255,255,225,255),1.40*Gsx,"default-bold","center",_,_,_,false,_,_)
		end
		
		--Health
		dxDrawRectangle(1635*Gsx,157*Gsy,280*Gsx,33*Gsy,tocolor(0,0,0,170),false)--Background
		
		dxDrawRectangle(1670*Gsx,160*Gsy,240*Gsx,27.5*Gsy,tocolor(120,0,0,255),false)
		dxDrawRectangle(1670*Gsx,160*Gsy,Settings.smoothMoveHealth*Gsx,13.5*Gsy,tocolor(160,0,0,255),false)
		dxDrawRectangle(1670*Gsx,173.5*Gsy,Settings.smoothMoveHealth*Gsx,13.5*Gsy,tocolor(200,0,0,255),false)
		dxDrawImage(1640*Gsx,160*Gsy,26*Gsx,26*Gsy,":"..ResourcePhad.."/Files/Health.png",0,0,0,tocolor(255,255,255,255),false)
		dxDrawText(health.."%",1990*Gsx,163*Gsy,1588*Gsx,30*Gsy,tocolor(255,255,225,255),1.40*Gsx,"default-bold","center",_,_,_,false,_,_)
		
		--Money
		dxDrawRectangle(1635*Gsx,197*Gsy,280*Gsx,33*Gsy,tocolor(0,0,0,170),false)--Background
		
		dxDrawRectangle(1670*Gsx,200*Gsy,240*Gsx,27.5*Gsy,tocolor(0,100,0,255),false)
		dxDrawImage(1640*Gsx,200*Gsy,26*Gsx,26*Gsy,":"..ResourcePhad.."/Files/Money.png",0,0,0,tocolor(255,255,255,255),false)
		dxDrawText("$"..convertMoneyToString(Settings.smoothMoveMoney),1990*Gsx,203*Gsy,1588*Gsx,30*Gsy,tocolor(255,255,225,255),1.40*Gsx,"default-bold","center",_,_,_,false,_,_)
	end
end)


--Dont edit this
function convertMoneyToString(money)
    local formatted=money;
    while true do  
        formatted,k=string.gsub(formatted,"^(-?%d+)(%d%d%d)",'%1,%2');
        if(k==0)then
			break;
		end
    end
    formatted=tostring(formatted);
    return formatted;
end