function create() {
    character.load('characters/' + character.character + '/sprites', AssetType.SPARROW, [ 'images_folder' => false ]);

    character.add_animation('danceLeft', 'GF Dancing Beat', 24, false, [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], [0, -9]);
    character.add_animation('danceRight', 'GF Dancing Beat', 24, false, [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], [0, -9]);

    character.dance_steps = ['danceLeft', 'danceRight'];
    character.dance();
}