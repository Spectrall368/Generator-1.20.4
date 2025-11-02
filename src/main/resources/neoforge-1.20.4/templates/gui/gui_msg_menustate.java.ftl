<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2025, Pylo, opensource contributors
 #
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <https://www.gnu.org/licenses/>.
 #
 # Additional permission for code generator templates (*.ftl files)
 #
 # As a special exception, you may create a larger work that contains part or
 # all of the MCreator code generator templates (*.ftl files) and distribute
 # that work under terms of your choice, so long as that work isn't itself a
 # template for code generation. Alternatively, if you modify or redistribute
 # the template itself, you may (at your option) remove this special exception,
 # which will cause the template and the resulting code generator output files
 # to be licensed under the GNU General Public License without this special
 # exception.
-->

<#-- @formatter:off -->
<#include "../procedures.java.ftl">

package ${package}.network;

@Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD) public class MenuStateUpdateMessage implements CustomPacketPayload {
    private final int elementType;
    private final String name;
    private final Object elementState;

	public static final ResourceLocation ID = new ResourceLocation(${JavaModName}.MODID, "guistate_update");

    public MenuStateUpdateMessage(int elementType, String name, Object elementState) {
        this.elementType = elementType;
        this.name = name;
        this.elementState = elementState;
    }

	public MenuStateUpdateMessage(FriendlyByteBuf buffer) {
		this.elementType = buffer.readInt();
		this.name = buffer.readUtf();
		Object elementState = null;
		if (elementType == 0) {
			elementState = buffer.readUtf();
		} else if (elementType == 1) {
			elementState = buffer.readBoolean();
		} else if (elementType == 2) {
         	elementState = buffer.readDouble();
		}
        this.elementState = elementState;
	}

	@Override public void write(final FriendlyByteBuf buffer) {
		buffer.writeInt(elementType);
		buffer.writeUtf(name);
		if (elementType == 0) {
			buffer.writeUtf((String) elementState);
		} else if (elementType == 1) {
			buffer.writeBoolean((boolean) elementState);
		} else if (elementType == 2 && elementState instanceof Number n) {
			buffer.writeDouble(n.doubleValue());
		}
	}

	@Override public ResourceLocation id() {
		return ID;
	}

	public static void handleMenuState(final MenuStateUpdateMessage message, final PlayPayloadContext context) {
		<#-- Security measure to prevent accepting too big strings -->
		if (message.name.length() > 256 || message.elementState instanceof String string && string.length() > 8192)
			return;

		context.workHandler().submitAsync(() -> {
			if (context.player().get().containerMenu instanceof ${JavaModName}Menus.MenuAccessor menu) {
				menu.getMenuState().put(message.elementType + ":" + message.name, message.elementState);
				if (context.flow() == PacketFlow.CLIENTBOUND && Minecraft.getInstance().screen instanceof ${JavaModName}Screens.ScreenAccessor accessor) {
					accessor.updateMenuState(message.elementType, message.name, message.elementState);
				}
			}
		}).exceptionally(e -> {
			context.packetHandler().disconnect(Component.literal(e.getMessage()));
			return null;
		});
	}

	@SubscribeEvent public static void registerMessage(FMLCommonSetupEvent event) {
		${JavaModName}.addNetworkMessage(MenuStateUpdateMessage.ID, MenuStateUpdateMessage::new, MenuStateUpdateMessage::handleMenuState);
	}

}
<#-- @formatter:on -->