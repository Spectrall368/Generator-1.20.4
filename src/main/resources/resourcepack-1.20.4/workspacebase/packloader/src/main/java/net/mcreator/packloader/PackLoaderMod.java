package net.mcreator.packloader;

import net.neoforged.fml.loading.FMLPaths;
import net.neoforged.fml.event.lifecycle.FMLClientSetupEvent;
import net.neoforged.fml.common.Mod;
import net.neoforged.bus.api.SubscribeEvent;
import net.neoforged.bus.api.IEventBus;
import net.neoforged.api.distmarker.Dist;

import net.minecraft.client.Minecraft;

import java.util.List;
import java.util.LinkedList;
import java.util.ArrayList;

import java.nio.file.Path;

import java.io.File;

@Mod(PackLoaderMod.MODID) public class PackLoaderMod {

	public static final String MODID = "packloader";

	public PackLoaderMod(IEventBus modEventBus) {
	}

    @Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD, value = Dist.CLIENT) {
		@SubscribeEvent public static void onClientSetup(FMLClientSetupEvent event) {
			List<String> resourcePacks = new ArrayList<>();
			var resourcePacksPath = FMLPaths.getOrCreateGameRelativePath(Path.of("resourcepacks"));
			if (resourcePacksPath.toFile().exists()) {
				File[] files = resourcePacksPath.toFile().listFiles();
				if (files != null) {
					for (var file : files) {
						resourcePacks.add(file.getName());
					}
				}
			}

			boolean anyChanged = false;
			List<String> selectedPacks = new LinkedList<>(Minecraft.getInstance().getResourcePackRepository().getSelectedIds());
			var allPacks = Minecraft.getInstance().getResourcePackRepository().getAvailableIds();
			for (String pack : allPacks) {
				for (String resourcePack : resourcePacks) {
					if (pack.contains(resourcePack)) {
						anyChanged = true;
						selectedPacks.add(pack);
					}
				}
			}

			if (anyChanged) {
				Minecraft.getInstance().getResourcePackRepository().setSelected(selectedPacks);
				Minecraft.getInstance().options.updateResourcePacks(Minecraft.getInstance().getResourcePackRepository());
			}
		}
	}

}
