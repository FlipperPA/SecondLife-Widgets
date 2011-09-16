// FlipperPA's auto-transparent minimum lag pose thingy.

// STEP 1: Drop your pose into an object inventory with this script (only 1)
// STEP 2: Simply enter the text you wish to hover about the pose object below

string DISPLAY_TEXT = "!";

// STEP 3: Hit "SAVE" below. If you change the pose, you can reset the script to re-read the pose
// by typing "/1 reset" into chat within listen range of the script.



/////////////////////// DO NOT CHANGE BELOW ////////////////////////
string ANIMATION;
integer is_sitting;

default
{
    state_entry()
    {
        ANIMATION = llGetInventoryName(INVENTORY_ANIMATION, 0);
        is_sitting = 0;
        llListen(1,"","","");
        llSitTarget(<0,0,.1>,ZERO_ROTATION);
        llSetTexture("5748decc-f629-461c-9a36-a35a221fe21f",ALL_SIDES);
        
        llSetText(DISPLAY_TEXT,<1,1,1>,1);
    }
    
    changed(integer change)
    {
        if(change & CHANGED_LINK)
        {
            key av = llAvatarOnSitTarget();
            
            if(av != NULL_KEY)
            {
                llRequestPermissions(av, PERMISSION_TRIGGER_ANIMATION);
            }
            else
            {
                if((llGetPermissions() & PERMISSION_TRIGGER_ANIMATION) && is_sitting)
                {
                    is_sitting = 0;
                    llStopAnimation(ANIMATION);
                    llSetTexture("5748decc-f629-461c-9a36-a35a221fe21f",ALL_SIDES);
                    llSetText(DISPLAY_TEXT,<1,1,1>,1);
                }
            }
        }
        ANIMATION = llGetInventoryName(INVENTORY_ANIMATION, 0);
    }
    
    run_time_permissions(integer perm)
    {
        if(perm & PERMISSION_TRIGGER_ANIMATION)
        {
            is_sitting = 1;
            llStopAnimation("sit_generic");
            llStopAnimation("sit");
            llStartAnimation(ANIMATION);
            llSetTexture("f54a0c32-3cd1-d49a-5b4f-7b792bebc204",ALL_SIDES);
            llSetText("",<1,1,1>,1);
        }
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if(!is_sitting)
        {
            if(message == "show")
            {
                llSetTexture("5748decc-f629-461c-9a36-a35a221fe21f",ALL_SIDES);
                llSetText(DISPLAY_TEXT,<1,1,1>,1);
            }
            else if(message == "hide")
            {
                llSetTexture("f54a0c32-3cd1-d49a-5b4f-7b792bebc204",ALL_SIDES);
                llSetText("",<1,1,1>,1);
            }
            else if(message == "reset" && id == llGetOwner())
            {
                llResetScript();
            }
        }
    }
    
    on_rez(integer start_param)
    {
        llResetScript();
    }
}
