string command = "";
string person = "";
string string1;
string string2;
string string3;
string cur_anim;
key owner;
vector mypos;
vector yourpos;
vector color;
integer distance;
integer i;

default
{
    state_entry()
    {
        owner = llGetOwner();
        llRequestPermissions(owner, PERMISSION_TRIGGER_ANIMATION);
        llListen(63,"",owner,"");
    }

    on_rez(integer st)
    {
        llResetScript();
    }

    attach(key attached)
    {
    owner=llGetOwner();
        if (attached != NULL_KEY)
        {
            llOwnerSay("FlipToy PLUS Activated! Operating on channel 63. Type '/63 commands' <enter> at any time in chat for a list of commands.");
        }
    }

    listen(integer channel, string name, key id, string message)
    {
        list strings = llParseString2List(message,[" "],[]);
        string string0=llToLower(llList2String(strings,0));
        string1=llList2String(strings,1); // args passed to other functions
        string2=llList2String(strings,2);
        string3=llList2String(strings,3);
        command = string0;
        if(command=="commands")
        {
            llOwnerSay("COMMANDS: FlipToy is operating on channel 63. All commands start with '/63'. 'f' or 'flip' kicks an avatar away from you. 'avs' lists all avatars within range.");
            llOwnerSay("COMMANDS: Example: /63 flip flipperpa peregrine");
            llOwnerSay("COMMANDS: Example: /63 f flipperpa peregrine");
            llOwnerSay("COMMANDS: 'flip all' or 'f a' will kick EVERYONE but yourself in range far away. This command only works on avatars that are standing.");
            llOwnerSay("COMMANDS: 'avs' lists all avatars within scanning range (96 meters) and how far away they are.");
            llOwnerSay("COMMANDS: The title command sets a title; the form is 'title [color] message'. If no color is specified, it defaults to the previous color. 'title' (with no color or message) removes the title from above your avatar.");
            llOwnerSay("COMMANDS: color can be: white, black, red, green, blue, pink, cyan, purple, yellow, orange");
            llOwnerSay("COMMANDS: Example: /63 title red This is a red message.");
            llOwnerSay("COMMANDS: Example: /63 title This message would appear in the previous color.");
            llOwnerSay("COMMANDS: Animations are now supported. The form is 'anim <animation one name> [animation two name] [delay in seconds]'. You can do one animation, two animations simultaneously, and even provide a delay between animation one and animation two.");
            llOwnerSay("COMMANDS: Typing 'anim list' lists all Linden animations. It can also trigger an animations in your inventory. Typing 'anim stop' stops the current animation, or 'anim stop_all' stop all halts all running animations (this is SLOW).");
            llOwnerSay("COMMANDS: Example: /63 anim sleep");
            llOwnerSay("COMMANDS: Example: /63 anim list");
            llOwnerSay("COMMANDS: Example: /63 anim stop");
        }            
        if(command=="flip" || command=="avs" || command=="f")
        {
            person = string1+" "+string2;
            person = llToLower(person);
            llSensor("","",AGENT,96,PI);
            if(command=="avs")
            {
                mypos=llGetPos();
            }
        }
        if(command=="title")
        {
            string title = "";
            string colorstring=llToLower(string1);
            if(colorstring=="blue")
            {
                color=<0,0,1>;
            }
            else if(colorstring=="orange")
            {
                color=<1,0.5,0>;
            }
            else if(colorstring=="cyan")
            {
                color=<0,1,1>;
            }
            else if(colorstring=="pink")
            {
                color=<1,0,1>;
            }
            else if(colorstring=="green")
            {
                color=<0,1,0>;
            }
            else if(colorstring=="red")
            {
                color=<1,0,0>;
            }
            else if(colorstring=="white")
            {
                color=<1,1,1>;
            }
            else if(colorstring=="yellow")
            {
                color=<1,1,0.1>;
            }
            else if(colorstring=="purple")
            {
                color=<0.7,0,0.7>;
            }
            else if(colorstring=="black")
            {
                color=<0,0,0>;
            }
            else
            {
                title=string1+" ";
            }
            integer i;
            for(i=2; i<=llGetListLength(strings); i++)
            {
                title = title + llList2String(strings,i) + " ";
            }
            llSetText(title, color, 1.0);   
        }

        if(command=="anim")
        {
            string animlist;
            if(string1=="stop_all" || string1=="list")
            {
                list ANIMATIONS  = [ "aim_L_bow", "aim_R_bazooka", "aim_R_handgun", "aim_R_rifle", "angry_fingerwag", "angry_tantrum", "away", "backflip", "blowkiss", "bow", "brush", "clap", "courtbow", "cross_arms", "crouch", "crouchwalk", "curtsy", "dance1", "dance2", "dance3", "dance4", "dance5", "dance6", "dance7", "dance8", "dead", "drink", "express_afraid", "express_anger", "express_bored", "express_cry", "express_embarrased", "express_laugh", "express_repulsed", "express_sad", "express_shrug", "express_surprise", "express_wink", "express_worry", "falldown", "female_walk", "fist_pump", "fly", "flyslow", "hello", "hold_R_bow", "hold_R_bazooka", "hold_R_handgun", "hold_R_rifle", "hold_throw_R", "hover", "hover_down", "hover_up", "impatient", "jump", "jumpforjoy", "kick_roundhouse_R", "kissmybutt", "kneel_left", "kneel_right", "land", "laugh_short", "motorcycle_sit" ];

                list ANIMATIONS2 = [ "musclebeach", "no_head", "no_unhappy", "nyanya", "peace", "point_me", "point_you", "prejump", "punch_L", "punch_onetwo", "punch_R", "RPS_countdown", "RPS_paper", "RPS_rock", "RPS_scissors", "run", "salute", "shoot_L_bow", "shout", "sit", "sit_female", "sit_ground", "sit_to_stand", "sleep", "slowwalk", "smoke_idle", "smoke_inhale", "smoke_throw_down", "snapshot", "soft_land", "stand", "standup", "stand_1", "stand_2", "stand_3", "stand_4", "stretch", "stride", "surf", "sword_strike_R", "talk", "throw_R", "tryon_shirt", "turnback_180", "turnleft", "turnright", "turn_180", "type", "uphillwalk", "walk", "whisper", "whistle", "wink_hollywood", "yell", "yes_happy", "yes_head", "yoga_float" ];

                ANIMATIONS += ANIMATIONS2;
                ANIMATIONS2 = [];

                integer animcount = llGetListLength(ANIMATIONS);
                integer i;
                if(string1=="stop_all")
                {
                    llOwnerSay("Stopping animations... this may take a moment.");
                }
                else
                {
                    animlist="ANIMATION LIST: ";
                }
                for (i=0; i<animcount; i++)
                {
                    if(string1=="stop_all")
                    {
                        llStopAnimation(llList2String(ANIMATIONS, i));
                    }
                    else
                    {
                        animlist=animlist+llList2String(ANIMATIONS,i)+" ";
                        if(((i+1)%20)==0)
                        {
                            llOwnerSay(animlist);
                            animlist="ANIMATION LIST: ";
                        }
                    }
                }
                ANIMATIONS=[];
            }
            else if(string1=="stop")
            {
                llStopAnimation(cur_anim);
            }
            else
            {
                if(llStringLength(cur_anim)) llStopAnimation(cur_anim);
                cur_anim=llGetSubString(message,5,100);
                llStartAnimation(cur_anim);
            }
            
        }       
    }
    
    sensor(integer total_number)
    {
        string avlist = "";
        for(i=0; i< total_number; i++)
        {
            if(command=="avs")
            {
                yourpos=llDetectedPos(i);
                distance=(integer)llVecDist(mypos,yourpos);
                avlist = avlist + (" [" + (string)(i+1) + "] " + llDetectedName(i)) + "@" + (string)distance + "M";
                if(llStringLength(avlist)>200)
                {
                    llOwnerSay(avlist);
                    avlist="";
                }
            }
            else
            {
                key personid = llDetectedKey(i);
                if(llToLower(llDetectedName(i))==person || person=="all " || person=="a ")
                {
                    llPushObject(personid, <99999999999,99999999999,99999999999>, <0,0,0>, TRUE);
                    llRezObject("FlipToy Bullet 1", llGetPos() + <0, 0, 2>, ZERO_VECTOR, ZERO_ROTATION, 0);
                    llSleep(1);
                    llWhisper(90215,llDetectedName(i));
                    llSleep(3);
                    distance=(integer)llVecDist(mypos,llDetectedPos(i));
                    if(distance!=0)
                    {
                        llRezObject("FlipToy Bullet 2", llGetPos() + <0, 0, 2>, ZERO_VECTOR, ZERO_ROTATION, 0);
                        llSleep(1);
                        llWhisper(90215,llDetectedName(i));
                        llSleep(3);
                    }
                }
            } 
        }
        if(command=="avs")
        {
            llOwnerSay(avlist);
        }
    }
}
