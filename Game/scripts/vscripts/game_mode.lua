require('settings')

function setup_game()
    mode = GameRules:GetGameModeEntity()        	
    mode:SetCameraDistanceOverride( CAMERA_DISTANCE_OVERRIDE )
    mode:SetUnseenFogOfWarEnabled(USE_UNSEEN_FOG_OF_WAR)

end