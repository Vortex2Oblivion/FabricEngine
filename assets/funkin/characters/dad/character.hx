function create() {
    character.load('characters/' + character.character + '/sprites', AssetType.SPARROW, [ 'images_folder' => false ]);

    character.add_animation('idle', 'Dad idle dance');

    character.add_animation('singLEFT', 'Dad Sing Note LEFT');
    character.add_animation('singDOWN', 'Dad Sing Note DOWN');
    character.add_animation('singUP', 'Dad Sing Note UP');
    character.add_animation('singRIGHT', 'Dad Sing Note RIGHT');

    character.dance();
}