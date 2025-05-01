<#include "procedures.java.ftl">
@Mod.EventBusSubscriber(value = {Dist.CLIENT}) public class ${name}Procedure {
	@SubscribeEvent public static void onRightClick(PlayerInteractEvent.RightClickEmpty event) {
		<#assign dependenciesCode><#compress>
			<@procedureDependenciesCode dependencies, {
				"x": "event.getPos().getX()",
				"y": "event.getPos().getY()",
				"z": "event.getPos().getZ()",
				"world": "event.getLevel()",
				"entity": "event.getEntity()"
			}/>
		</#compress></#assign>
		if (event.getHand() != event.getEntity().getUsedItemHand())
			return;
		PacketDistributor.SERVER.noArg().send(new ${name}Message());
		execute(${dependenciesCode});
	}

	@Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD)
	public record ${name}Message() implements CustomPacketPayload {
	    public static final ResourceLocation ID = new ResourceLocation(${JavaModName}.MODID, "procedure_${registryname}");

	    public ${name}Message(FriendlyByteBuf buffer) {
	        this();
	    }

	    @Override public void write(final FriendlyByteBuf buffer) {}

		@Override public ResourceLocation id() {
			return ID;
		}

		public static void handleData(final ${name}Message message, final PlayPayloadContext context) {
			if (context.flow() == PacketFlow.SERVERBOUND) {
				context.workHandler().submitAsync(() -> {
					if (!context.player().get().level().hasChunkAt(context.player().get().blockPosition()))
						return;
					<#assign dependenciesCode><#compress>
						<@procedureDependenciesCode dependencies, {
							"x": "context.player().get().getX()",
							"y": "context.player().get().getY()",
							"z": "context.player().get().getZ()",
							"world": "context.player().get().level()",
							"entity": "context.player().get()"
						}/>
					</#compress></#assign>
					execute(${dependenciesCode});
				}).exceptionally(e -> {
					context.packetHandler().disconnect(Component.literal(e.getMessage()));
					return null;
				});
			}
		}

		@SubscribeEvent public static void registerMessage(FMLCommonSetupEvent event) {
			${JavaModName}.addNetworkMessage(${name}Message.ID, ${name}Message::new, ${name}Message::handleData);
		}
	}