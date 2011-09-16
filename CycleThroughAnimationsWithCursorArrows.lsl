// MULTI ANIM SCRIPT

// CHANNEL TO LISTEN FOR "show" / "hide"
integer listen_channel = 10;

// SET DEBUG_MODE=1 TO SEE ANIM NAMES BEING SWITCHED TO
integer DEBUG_MODE = 1;

// THE TEXT THAT APPEARS ABOVE THE BALL AND IN PIE MENU
string sit_text = "LOUNGE";
string above_text = "CLICK ME TO LOUNGE HERE!";

// INSERT YOUR POSES HERE
list poses = [
"sit_ground",
"backflip",
"kick_roundhouse_R"
];

// INSERT YOUR OFFSETS HERE, IN THE SAME ORDER AS THE POSES
list offsets = [
<0,0,0>,
<0,0,-0.024>,
<0.3,-0.4,-0.454>
];

// INSERT YOUR ROTATIONS HERE, IN THE SAME ORDER AS POSES & ROTATIONS
list rotations = [
<0,0,10.0>,
<0,0,0>,
<0,0,0>
];

// INSERT DELAY TIMES FOR EACH ANIM TO AVOID BLEEDING BETWEEN ANIMS
list sleep_times = [
1.25,
1.25,
1.25
];

// MAIN CODE BELOW; YOU SHOULDN'T HAVE TO MODIFY
integer index = 0;
integer list_length = 0;
vector oriposs;
rotation orirot;

getPosRot()
{
    oriposs = llGetPos();
    orirot = llGetRot();
}

show_ball()
{
    llSetText(above_text,<1,1,1>,1.0);
    llSetTexture("5748decc-f629-461c-9a36-a35a221fe21f",ALL_SIDES);
}

hide_ball()
{
    llSetTexture("f54a0c32-3cd1-d49a-5b4f-7b792bebc204",ALL_SIDES);
    llSetText("",<1,1,1>,1.0);
}

entry()
{
    string play_anim = llList2String(poses,index);
    if(DEBUG_MODE==1) llSay(0,"Starting " + play_anim);
    llStartAnimation(play_anim);
    llSetRot(orirot + llEuler2Rot((vector)llList2String(rotations,index)));
    llSetPos(oriposs + (vector)llList2String(offsets,index));
}

default
{
    moving_end()
    {
        getPosRot();
    }

    on_rez(integer total_number)
    {
        oriposs = llGetPos();
        orirot = llGetRot();
    }
    
    state_entry()
    {
        list_length = llGetListLength(poses);
        oriposs = llGetPos();
        orirot = llGetRot();
        llListen(listen_channel,"",NULL_KEY,"");
        llSitTarget(<0,0,0.1>,ZERO_ROTATION);
        llSetText(above_text,<1,1,1>,1.0);
        llSetSitText(sit_text);
        llSetTexture("5748decc-f629-461c-9a36-a35a221fe21f",ALL_SIDES);
    }

    state_exit()
    {
        llSleep(0.5);
        llStopAnimation(llList2String(poses,index));
        llSleep(0.5);
    }

    touch_start(integer total)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
            llResetScript();
        }
    }

    listen(integer channel, string name, key id, string message)
    {
        if(message=="show")
        {
            show_ball();
        }
        if(message=="hide")
        {
            hide_ball();
        }
    }

    changed(integer change)
    {
        if (change & CHANGED_LINK)
        {
            if (llAvatarOnSitTarget() != NULL_KEY)
            {
                llRequestPermissions(llAvatarOnSitTarget(),PERMISSION_TRIGGER_ANIMATION|PERMISSION_TAKE_CONTROLS);
            }
            else
            {
                llStopAnimation(llList2String(poses,index));
            }
        }
    }

    run_time_permissions(integer perms)
    {
        if ((perms & PERMISSION_TRIGGER_ANIMATION|PERMISSION_TAKE_CONTROLS) == PERMISSION_TRIGGER_ANIMATION|PERMISSION_TAKE_CONTROLS)
        {
            llStopAnimation("sit");
            llTakeControls(CONTROL_FWD|CONTROL_BACK|CONTROL_ROT_LEFT|CONTROL_ROT_RIGHT,TRUE,FALSE);
            state pose;
        }
    }
}

state pose
{
    moving_end()
    {
        getPosRot();
    }

    state_entry()
    {
        index = 0;
        llListen(listen_channel,"",NULL_KEY,"");
        llStartAnimation(llList2String(poses,index));
        llSetPos(oriposs + (vector)llList2String(offsets,index));
        llSetRot(orirot + llEuler2Rot((vector)llList2String(rotations,index)));
        llSetTexture("f54a0c32-3cd1-d49a-5b4f-7b792bebc204",ALL_SIDES);
        llSetText("",<1,1,1>,1.0);
    }

    state_exit()
    {
        llSleep(0.5);
        llStopAnimation(llList2String(poses,index));
        llSleep(0.5);
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if(message=="show")
        {
            show_ball();
        }
        if(message=="hide")
        {
            hide_ball();
        }
    }
    
    changed(integer change)
    {
        if (change & CHANGED_LINK)
        {
            if (llAvatarOnSitTarget() == NULL_KEY)
            {
                llReleaseControls();
                llStopAnimation(llList2String(poses,index));
                state reset;
            }
        }
    }
    
    control(key id, integer level, integer edge)
    {
        if(edge==level)
        {
            if(DEBUG_MODE==1) llSay(0,"Stopping " + llList2String(poses,index));
            llStopAnimation(llList2String(poses,index));
            llSleep((float)llList2String(sleep_times,index));
            if ((edge & level & CONTROL_FWD))
            {
                index++;
            }
            else if ((edge & level & CONTROL_BACK))
            {
                index--;
            }
            else if ((edge & level & CONTROL_ROT_RIGHT))
            {
                index=(list_length - 1);
            }
            else if ((edge & level & CONTROL_ROT_LEFT))
            {
                index=0;
            }
            if(index>(list_length - 1)) index=0;
            if(index<0) index=(list_length - 1);
            entry();
        }
    }
}

state reset
{
    state_entry()
    {
        llSetPos(oriposs);
        llSetRot(orirot);
        llResetScript();
    }
}
