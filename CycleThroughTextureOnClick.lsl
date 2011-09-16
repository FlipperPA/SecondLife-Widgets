integer total = 0;
integer current = 0;

default
{
    state_entry()
    {
        total = llGetInventoryNumber(INVENTORY_TEXTURE);
    }
    
    changed(integer change)
    {
        llResetScript();
    }

    touch_start(integer total_number)
    {
        if(current >= total) current = 0;
        string name = llGetInventoryName(INVENTORY_TEXTURE, current);
        if (name != "") llSetTexture(name, ALL_SIDES);
        current++;
        // llSetText("Click Below to See More: " + (string)current + "/" + (string)total, <0,1,0>, 1);
    }
}
