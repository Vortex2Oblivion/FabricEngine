package funkin.scenes;

/**
 * Base state class to use for all states in the `funkin` package.
 * @author Leather128
 */
class FunkinScene extends flixel.addons.ui.FlxUIState {
    /**
     * Beat (4th note) of the song on the previous frame.
     */
    private var last_beat:Int = 0;

    /**
     * Step (16th note) of the song on the previous frame.
     */
    private var last_step:Int = 0;

    /**
     * Whether or not to clear the cache on scene loading.
     */
    private var clear_cache:Bool = true;

    /**
     * @param clear_cache Whether or not to automatically clear the cache when transitioning into this scene.
     */
    public function new(?clear_cache:Bool = true) {
        super();
        this.clear_cache = clear_cache;
    }

    override function create():Void {
        // set framerate just in case
        FlxG.stage.frameRate = 1000;

        if (clear_cache) {
            clear_memory();
        }

        super.create();
    }

    override function update(elapsed:Float):Void {
        // Music stuff //

        // Set float beat and step
        Conductor.beat_f = Conductor.song_position / Conductor.time_between_beats;
        Conductor.step_f = Conductor.song_position / Conductor.time_between_steps;

        // Set normal beat and step
        Conductor.beat = Math.floor(Conductor.beat_f); Conductor.step = Math.floor(Conductor.step_f);

        if (Conductor.beat > last_beat) on_beat();
        if (Conductor.step > last_step) on_step();

        // Set old beat and step to the current ones after detecting changes
        last_beat = Conductor.beat; last_step = Conductor.step;

        // We reload state here instead of in the same place as fullscreen just to allow states to manually do things before the state gets reloaded (could be useful)
        if (Input.is('f5')) FlxG.resetState();

        super.update(elapsed);
    }

    // Replace these functions with your own in your states!

    /**
     * Function that gets called on every beat (4th note) of the song.
     */
    public function on_beat():Void {};

    /**
     * Function that gets called on every step (16th note) of the song.
     */
    public function on_step():Void {};

    // overrides
    override function onFocus() {
        super.onFocus();
        // re set the framerate here because it gets turned back to 60 if we don't
        FlxG.stage.frameRate = 1000;
    }

    override function openSubState(sub_state:flixel.FlxSubState):Void {
        persistentUpdate = false;
        super.openSubState(sub_state);
    }

    override function closeSubState():Void {
        persistentUpdate = true;
        super.closeSubState();
    }

    /**
     * Clears all assets and other objects from the game's memory.
     */
    public static function clear_memory():Void {
        // Remove cached assets (prevents memory leaks that i can prevent)
            
        // Remove lingering sounds from the sound list
        FlxG.sound.list.forEachAlive(function(sound:flixel.system.FlxSound):Void { FlxG.sound.list.remove(sound, true); sound.stop(); sound.destroy(); });
        FlxG.sound.list.clear();

        FlxG.bitmap.mapCacheAsDestroyable();
        FlxG.bitmap.clearCache();

        // Clear actual assets from OpenFL and Lime itself
        var cache:openfl.utils.AssetCache = cast openfl.utils.Assets.cache;
        var lime_cache:lime.utils.AssetCache = cast lime.utils.Assets.cache;

        // this totally isn't copied from polymod/backends/OpenFLBackend.hx trust me
        for (key in cache.bitmapData.keys()) cache.bitmapData.remove(key);
        for (key in cache.font.keys()) cache.font.remove(key);
        @:privateAccess
        for (key in cache.sound.keys()) { cache.sound.get(key).close(); cache.sound.remove(key); }

        // this totally isn't copied from polymod/backends/LimeBackend.hx trust me
        for (key in lime_cache.image.keys()) lime_cache.image.remove(key);
        for (key in lime_cache.font.keys()) lime_cache.font.remove(key);
        for (key in lime_cache.audio.keys()) { lime_cache.audio.get(key).dispose(); lime_cache.audio.remove(key); };
        
        // Clear cached assets from the asset cache.
        Assets.clear_cache();

        // Run built-in garbage collector
        openfl.system.System.gc();
    }
}
