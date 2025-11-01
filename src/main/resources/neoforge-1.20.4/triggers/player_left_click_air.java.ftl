<#include "procedures.java.ftl">
@Mod.EventBusSubscriber(value = {Dist.CLIENT}) public class ${name}Procedure {
	@SubscribeEvent public static void onLeftClick(PlayerInteractEvent.LeftClickEmpty event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
				"x": "event.getPos().getX()",
				"y": "event.getPos().getY()",
				"z": "event.getPos().getZ()",
				"world": "event.getLevel()",
				"entity": "event.getEntity()"
			}/>
		</#assign>
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
					<#assign dependenciesCode>
						<@procedureDependenciesCode dependencies, {
							"x": "context.player().get().getX()",
							"y": "context.player().get().getY()",
							"z": "context.player().get().getZ()",
							"world": "context.player().get().level()",
							"entity": "context.player().get()"
						}/>
					</#assign>
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