default
{
    on_rez(integer nevermind)
    {
    }

    touch_start(integer total_number)
    {
        list        inventory;
        string      name;
        integer     num = llGetInventoryNumber(INVENTORY_ALL);
        string      text = llGetObjectName() + " is unpacking...\n";
        integer     i;
 
        for (i = 0; i < num; ++i) {
            name = llGetInventoryName(INVENTORY_ALL, i);

            if(llGetInventoryPermMask(name, MASK_NEXT) & PERM_COPY)
            {
                inventory += name;
            }
        }
 
        i = llListFindList(inventory, [llGetScriptName()]);
        inventory = llDeleteSubList(inventory, i, i);
 
        if (llGetListLength(inventory) < 1) 
        {
            llSay(0, "No items to offer.");
        }
        else
        {
            llGiveInventoryList(llGetOwner(), text, inventory);
            llOwnerSay("Your new "+ text +" can be found in your inventory, in a folder called '"+ text +"'. Drag it onto your avatar to wear it!");
        }
    }
}
