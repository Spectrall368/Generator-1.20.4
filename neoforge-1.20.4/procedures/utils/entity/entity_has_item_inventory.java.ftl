private static boolean hasEntityInInventory(Entity entity, ItemStack itemstack) {
	if (entity instanceof Player player) {
	    List<NonNullList<ItemStack>> compartments = ObfuscationReflectionHelper.getPrivateValue(Inventory.class, player.getInventory(), "compartments");
        for (List<ItemStack> list : compartments) {
            for (ItemStack itemstack2 : list) {
                if (!itemstack2.isEmpty() && ItemStack.isSameItem(itemstack2, itemstack)) {
                    return true;
                }
            }
        }
    }
	return false;
}