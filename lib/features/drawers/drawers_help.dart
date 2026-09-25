/// Les explications des champs des Tiroirs, groupées pour se relire d'un bloc.
library;

import '../../core/widgets/field_help.dart';

const kAboutOpening = FieldHelp(
  title: 'Ouverture',
  body:
      'Cotes intérieures du caisson, là où vont les tiroirs : entre les '
      'flancs, entre le fond et le dessus, du chant au panneau arrière.',
);

const kAboutFrontHeights = FieldHelp(
  title: 'Hauteurs des façades',
  body:
      'Par défaut, les façades se partagent la hauteur à parts égales. Une '
      'hauteur fixée reste fixe, et les autres façades se partagent le reste.',
);

const kAboutSlide = FieldHelp(
  title: 'Glissière',
  body: 'Elle fixe le jeu entre les flancs et la caisse, et sa longueur.',
  bullets: [
    'À billes : glissière latérale, 12,7 mm de jeu de chaque côté.',
    'Sous tiroir : glissière cachée sous la caisse. Elle impose un fond en '
        'retrait. Cotes indicatives, à vérifier sur la fiche du fabricant.',
    'Bois sur bois : le tiroir coulisse sur des coulisseaux en bois, sans '
        'quincaillerie.',
    'Personnalisée : les jeux de votre fiche fabricant.',
  ],
);

const kAboutFrontMount = FieldHelp(
  title: 'Pose de la façade',
  body: 'Où se pose la façade par rapport au caisson.',
  bullets: [
    'Applique : devant le caisson. La façade recouvre le chant des flancs.',
    'Encastrée : dans l’ouverture. La façade affleure le chant, avec un jeu '
        'tout autour.',
  ],
);

const kAboutBoxJoint = FieldHelp(
  title: 'Assemblage',
  body:
      'Quelles pièces courent d’un bout à l’autre. Il change la longueur du '
      'devant, du dos et des côtés, pas le type d’assemblage.',
);

const kAboutBottomMount = FieldHelp(
  title: 'Fond',
  body: 'Comment le fond tient dans la caisse.',
  bullets: [
    'En rainure : pris dans une rainure des quatre pièces. Il dépasse de la '
        'profondeur de rainure de chaque côté.',
    'Entre les côtés : posé à l’intérieur sans rainure, vissé, collé ou sur '
        'tasseaux. Il fait les cotes intérieures de la caisse.',
    'Sous la caisse : vissé ou cloué dessous, aux dimensions hors tout.',
  ],
);

const kAboutSlideLength = FieldHelp(
  title: 'Longueur de glissière',
  body:
      'Par défaut, la plus grande longueur vendue qui tient dans la '
      'profondeur. Imposez-en une si vous avez déjà vos glissières.',
);
