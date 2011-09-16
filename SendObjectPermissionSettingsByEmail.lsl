// By FlipperPA Peregrine... no guarantees, written quickly to help sellers.
// This script will 
// FILL IN YOUR EMAIL ADDRESS BELOW

string email_address = "you@yourdomain.com";

// FILL IN THE NUMBER OF DAYS INTERVAL BETWEEN EMAIL NOTIFICATIONS BELOW, OR 0 TO DISABLE
// 1 = DAILY EMAIL
// 7 = WEEKLY EMAIL
// 14 = FORTNIGHT EMAIL

integer interval_days = 0;

/////////////////////
// YOU SHOULDN'T HAVE TO CHANGE ANYTHING BELOW HERE
/////////////////////

perm_items(integer email_yn)
{
    integer content_num = llGetInventoryNumber(INVENTORY_ALL);
    integer x;
    integer perm_mask;
    string item_name;
    string return_txt;
    string email_txt;
    content_num--;

    for(x=0; x<=content_num; x++)
    {
        item_name=llGetInventoryName(INVENTORY_ALL, x);
        perm_mask=llGetInventoryPermMask(item_name, MASK_NEXT);

        return_txt+=item_name + " ( ";
        if(perm_mask & PERM_MODIFY) return_txt+="Mod ";
        if(perm_mask & PERM_COPY) return_txt+="Copy ";
        if(perm_mask & PERM_TRANSFER) return_txt+="Transfer ";
        return_txt+=")\n";

        if(email_yn)
        {
            if(llStringLength(return_txt)>3000)
            {
                llEmail(email_address,"SL Permissions Report", return_txt);
                return_txt="";
            }
        }
        else
        {
            llOwnerSay(return_txt);
            return_txt="";
        }
    }

    if(email_yn)
    {
        llEmail(email_address,"SL Permissions Report", return_txt);
    }
}

default
{
    state_entry()
    {
        if(interval_days)
        {
            llSetTimerEvent(86400 * interval_days);
        }
    }
    
    timer()
    {
        perm_items(1);
    }

    touch_start(integer total_number)
    {
        if(llDetectedKey(0) == llGetOwner())
        {
            perm_items(0);
        }
    }
    
    on_rez(integer total_number)
    {
        llResetScript();
    }
}
