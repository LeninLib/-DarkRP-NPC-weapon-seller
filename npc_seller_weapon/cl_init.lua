
include('shared.lua')

function ENT:Draw()
	self:DrawModel()
	local pos = self:GetPos()
	local ang = self:GetAngles()
		cam.Start3D2D(pos + Vector(0, 0, 80), ang + Angle(0, 90, 90), .50)
		draw.SimpleText("Продавец оружия", 'L_WSF1' ,0,0 ,Color(255,255,255) ,1 , 1 )
	cam.End3D2D()
end
--
surface.CreateFont("L_WSF1", {font = "izvestija",size = 30,extended = true,})
surface.CreateFont("L_WSF2", {font = "izvestija",size = 20,extended = true,})

DrawMainMenu = function( ent )
local ply = LocalPlayer()
local PESWCOLOR1 =  Color(0, 0,0,200)
local PESWCOLOR2 =  Color(255,255,255)
local Framenachal= vgui.Create("DFrame")
Framenachal:SetTitle("")
Framenachal:SetSize(ScrW()/1.5, ScrH()/1.5)
Framenachal:SetPos(ScrW()/2,ScrH()/2 )
Framenachal:MakePopup()
Framenachal:Center()
Framenachal:ShowCloseButton(false)
Framenachal.Paint = function( self, w, h )
draw.RoundedBox( 0, 0, 0, w, h, Color(0,0,0,200) )
surface.SetDrawColor(255,255,255)
surface.DrawOutlinedRect(0,0,w,h)
	

end
local contaiter = vgui.Create("DBubbleContainer",Framenachal)	
	contaiter:SetPos(Framenachal:GetTall()*.025,Framenachal:GetWide()*.01)
	contaiter:SetSize(Framenachal:GetTall()*1.74,Framenachal:GetWide()/2.15)
	contaiter.Paint = function( self, w, h )
	surface.SetDrawColor(255,255,255)
surface.DrawOutlinedRect(0,0,w,h)
	end

local mainframescroll = vgui.Create( "DScrollPanel", contaiter )
	mainframescroll:Dock( FILL )
	
		for k,v in pairs( CustomShipments ) do --Looks over all recipes in the main ZavodTable table
		
			local mainbuttons = vgui.Create( "DButton", mainframescroll )
			mainbuttons:SetText( string.upper(v.name) .. "  -  " ..string.upper(v.price) .."$ ")
			mainbuttons:SetSize(nil,mainframescroll:GetTall()*1.75)
			mainbuttons:SetFont("L_WSF2")
			mainbuttons:SetTextColor( PESWCOLOR2  )
			mainbuttons:Dock( TOP )
			mainbuttons:DockMargin( 0, 0, 0, 2.5 )
			mainbuttons.Paint = function( self, w, h )


			if mainbuttons:IsHovered() then
				mainbuttons:SetTextColor(Color(224,139,11))
				surface.SetDrawColor(255,0,0)
				surface.DrawOutlinedRect(0,0,w,h)
			  else
				mainbuttons:SetTextColor(Color(255,255,255))
				surface.SetDrawColor(255,255,255)
				surface.DrawOutlinedRect(0,0,w,h)
			  end
			end
			mainbuttons.DoClick = function()		
				surface.PlaySound( "buttons/lightswitch2.wav" )
				net.Start("EntGiveBuyedWeapon")
				net.WriteUInt(k,32)
				net.SendToServer()

			end
		end



local closebutton1 = vgui.Create("DButton",Framenachal)
closebutton1:SetText("Закрыть")
closebutton1:SetFont( "L_WSF1" )
closebutton1:SetTextColor(PESWCOLOR2)
closebutton1:SetPos(Framenachal:GetWide()*.40,Framenachal:GetTall()*.90)
 closebutton1:SetSize(Framenachal:GetTall()*.3,Framenachal:GetWide()*.05)
 closebutton1.Paint = function (self,w,h)
   draw.RoundedBox(2, 0,0, w, h, Color(125,0,0,255))   
      surface.SetDrawColor(255,255,255)
      surface.DrawOutlinedRect(0,0,w,h) 
	  if closebutton1:IsHovered() then
		closebutton1:SetTextColor(Color(224,139,11))
	  else
		closebutton1:SetTextColor(Color(255,255,255))
	  end

	 
 end
 closebutton1.DoClick = function ()
   Framenachal:SetVisible(false)
   surface.PlaySound( "buttons/lightswitch2.wav" )



end
end
net.Receive( "Message_PESW", function( len, ply ) --Have to network the entname into here since the client can't see it serverside
	local validfunction = net.ReadBool()
	local entname = net.ReadString()
	if validfunction then --Checks to make sure the spawn function exists, I might have it go through a default spawn function at some point instead of just erroring
		chat.AddText( Color( 100, 100, 255 ), "[Продавец оружия]: ", Color( 255, 255, 255 ), "Вы купили оружие : "..entname.." ." )
	else
		chat.AddText( Color( 100, 100, 255 ), "[Продавец оружия]: ", Color( 255, 255, 255 ), "Ошибка. Вы пошли нах*й "..entname.." ("..ent..")" )
	end
end )

net.Receive( "EntSellerTable", function( len, ply )
	local ent = net.ReadEntity()
	DrawMainMenu( ent )
end )
