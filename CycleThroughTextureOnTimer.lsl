// By FlipperPA - look and learn!

// The variable below is used for storing the total number of textures in inventory
integer total = 0;
// The variable below is used to keep track of which texture is currently being shown on the prim
integer current = 0;
// The variable below is used to tell the script how many seconds to wait between changing textures
integer time_delay = 20;


default
{
    state_entry()
    {
        // Set the timer event to run
        llSetTimerEvent(time_delay);
    }
    
    changed(integer change)
    {
        // When a change occurs to inventory, re-count the total number of textures
        total = llGetInventoryNumber(INVENTORY_TEXTURE);
    }

    timer()
    {
        // Logic to display the texture; if the current texture is higher than the total number
        // loop back to the first texture
        if(current >= total) current = 0;
        string name = llGetInventoryName(INVENTORY_TEXTURE, current);
        if (name != "") llSetTexture(name, ALL_SIDES);
        current++;
    }
}
