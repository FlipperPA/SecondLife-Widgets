string last_url = "";

default
{
    state_entry()
    {
        llListen(0,"","","");
    }

    listen(integer ch, string name, key k, string msg){
        integer a = llSubStringIndex(msg,"http://");
        integer b = llSubStringIndex(msg,"www.");
        if(a > -1 || b > -1){
            if(a > -1){
                string temp = llGetSubString(msg,a,512);
                integer c = llSubStringIndex(temp," ");
                if(c > -1){
                    temp = llGetSubString(temp,0,c);
                }
                last_url = temp;
            }else if(b > -1){
                string temp = llGetSubString(msg,b,512);
                integer c = llSubStringIndex(temp," ");
                if(c > -1){
                    temp = llGetSubString(temp,0,c);
                }
                last_url = "http://" + temp;
            }
            llLoadURL(llGetOwner(), name + " gave a URL.", last_url);
        }
    }
}
