:- encoding(utf8).

%pergunta(Numero, 'Pergunta?', 
%         ['Opção A','Opção B','Opção C','Opção D'], 
%         'Letra_da_Resposta_Correcta').
         
pergunta(1, 'Qual é o plural da palavra pão?',
         ['A - Pães','B - Pãos','C - Pãoses','D - Pãezes'],
         'A').

pergunta(2, 'Quantos dias tem o mês de Fevereiro num ano comum?',
         ['A - 28','B - 29','C - 30','D - 31'],
         'A').

pergunta(3, 'Qual é o símbolo químico da água?',
         ['A - H2O','B - O2','C - CO2','D - HO'],
         'A').

pergunta(4, 'Em que continente se encontra Portugal?',
         ['A - Ásia','B - América','C - Europa','D - África'],
         'C').

pergunta(5, 'Qual é o planeta mais próximo do Sol?',
         ['A - Vénus','B - Mercúrio','C - Marte','D - Terra'],
         'B').

pergunta(6, 'Quem escreveu "Os Lusíadas"?',
         ['A - Camilo Castelo Branco','B - Padre António Vieira','C - Eça de Queirós','D - Luís de Camões'],
         'D').

pergunta(7, 'Em que ano começou a Segunda Guerra Mundial?',
         ['A - 1939','B - 1941','C - 1918','D - 1945'],
         'A').

pergunta(8, 'Qual é a capital da Noruega?',
         ['A - Oslo','B - Estocolmo','C - Helsínquia','D - Copenhaga'],
         'A').

pergunta(9, 'Qual é o maior oceano do planeta?',
         ['A - Atlântico','B - Índico','C - Pacífico','D - Ártico'],
         'C').

pergunta(10, 'Quem pintou a Mona Lisa?',
         ['A - Michelangelo','B - Leonardo da Vinci','C - Botticelli','D - Rafael'],
         'B').

pergunta(11, 'Qual destes números é primo?',
         ['A - 21','B - 33','C - 37','D - 49'],
         'C').

pergunta(12, 'O que mede a escala Richter?',
         ['A - Velocidade do vento','B - Intensidade sísmica','C - Temperatura','D - Radiação'],
         'B').

pergunta(13, 'Qual é o maior deserto do mundo?',
         ['A - Saara','B - Gobi','C - Antárctida','D - Kalahari'],
         'C').

pergunta(14, 'Quem formulou a teoria da relatividade?',
         ['A - Newton','B - Einstein','C - Tesla','D - Bohr'],
         'B').

pergunta(15, 'Qual é o elemento químico com símbolo Au?',
         ['A - Alumínio','B - Prata','C - Ouro','D - Argónio'],
         'C').

%Perguntas de reserva
/*
pergunta(16, 'Em que país surgiu o Renascimento?',
         ['A - França','B - Itália','C - Alemanha','D - Espanha'],
         'B').

pergunta(17, 'Qual é o maior rio da América do Sul?',
         ['A - Amazonas','B - Orinoco','C - São Francisco','D - Madeira'],
         'A').

pergunta(18, 'Qual destas obras é de Shakespeare?',
         ['A - Crime e Castigo','B - Dom Quixote','C - Hamlet','D - Fausto'],
         'C').

pergunta(19, 'Quem descobriu a penicilina?',
         ['A - Fleming','B - Curie','C - Pasteur','D - Darwin'],
         'A').

pergunta(20, 'Qual é a estrela mais próxima da Terra depois do Sol?',
         ['A - Sirius','B - Betelgeuse','C - Proxima Centauri','D - Vega'],
         'C').
*/

% Perguntas em Inglês
/*
% --- LEVEL 1 ($100) ADDITIONS ---
question(1, 'Which color is a stop sign?', 'Green', 'Blue', 'Red', 'Yellow', 'c').
question(1, 'How many legs does a dog typically have?', 'Two', 'Four', 'Six', 'Eight', 'b').
question(1, 'What sounds does a cow make?', 'Meow', 'Woof', 'Moo', 'Quack', 'c').
question(1, 'Which of these is NOT a fruit?', 'Apple', 'Banana', 'Steak', 'Orange', 'c').
question(1, 'What is the opposite of "Hot"?', 'Cold', 'Warm', 'Spicy', 'Dry', 'a').
question(1, 'Which shape has no corners?', 'Square', 'Triangle', 'Circle', 'Rectangle', 'c').
question(1, 'Who lives in a pineapple under the sea?', 'SpongeBob', 'Patrick', 'Squidward', 'Mr. Krabs', 'a').
question(1, 'What do you wear on your feet?', 'Gloves', 'Hat', 'Shoes', 'Scarf', 'c').

% --- LEVEL 2 ($200) ADDITIONS ---
question(2, 'Which planet do we live on?', 'Mars', 'Earth', 'Jupiter', 'Saturn', 'b').
question(2, 'How many days are in a week?', '5', '7', '10', '12', 'b').
question(2, 'Which Disney character is a mouse?', 'Donald', 'Goofy', 'Pluto', 'Mickey', 'd').
question(2, 'What is frozen water called?', 'Steam', 'Ice', 'Rain', 'Fog', 'b').
question(2, 'Which of these is a primary color?', 'Purple', 'Orange', 'Green', 'Blue', 'd').
question(2, 'What does a caterpillar turn into?', 'Worm', 'Butterfly', 'Spider', 'Fly', 'b').
question(2, 'Which superhero climbs walls like a spider?', 'Superman', 'Batman', 'Spider-Man', 'Iron Man', 'c').
question(2, 'What do you use to write on a blackboard?', 'Pen', 'Pencil', 'Chalk', 'Marker', 'c').

% --- LEVEL 3 ($300) ADDITIONS ---
question(3, 'What is the capital city of Portugal?', 'Porto', 'Lisbon', 'Coimbra', 'Faro', 'b').
question(3, 'Who is the brother of Mario in video games?', 'Wario', 'Bowser', 'Peach', 'Luigi', 'd').
question(3, 'What is the largest mammal in the world?', 'Elephant', 'Blue Whale', 'Giraffe', 'Rhino', 'b').
question(3, 'Which of these is a vegetable?', 'Grape', 'Carrot', 'Cherry', 'Melon', 'b').
question(3, 'How many cents make a dollar?', '10', '50', '100', '1000', 'c').
question(3, 'Which season comes after Summer?', 'Spring', 'Winter', 'Autumn', 'Monsoon', 'c').
question(3, 'What is the main ingredient in an omelet?', 'Flour', 'Eggs', 'Sugar', 'Milk', 'b').
question(3, 'Which Portuguese city is famous for its fortified wine?', 'Braga', 'Evora', 'Lagos', 'Porto', 'd').

% --- LEVEL 4 ($500) ADDITIONS ---
question(4, 'A 1969 film was titled Butch Cassidy and the Sundance...what?', 'Baby', 'Boy', 'Kid', 'Film Festival', 'c').
question(4, 'Which of these is a knitted garment?', 'Sweater', 'Perspier', 'Swelterer', 'Moisturer', 'a').
question(4, 'Which of these is a period of twelve months?', 'Week', 'Century', 'Year', 'Day', 'c').
question(4, 'What do Bees gather in order to make Honey?', 'Yeast', 'Nectar', 'Eggs', 'Self-Raising Flour', 'b').
question(4, 'What type of animal was King Kong in the film of the same name?', 'Lion', 'Dinosaur', 'Dog', 'Ape', 'd').
question(4, 'Which of these is a famous Hollywood actor?', 'Westwood', 'Northwood', 'Eastwood', 'Southwood', 'c').
question(4, 'What are the joints of the fingers called?', 'Knees', 'Knuckles', 'Ankles', 'Elbows', 'b').
question(4, 'Crimson is a shade of which colour?', 'Blue', 'Yellow', 'Red', 'Green', 'c').

% --- LEVEL 5 ($1,000) ADDITIONS ---
question(5, 'Which of these is a creature with many legs?', 'Milligram', 'Millipede', 'Millisecond', 'Millimetre', 'b').
question(5, 'If something is described as being a "cinch", what is it said to be?', 'Easy', 'Lazy', 'Cozy', 'Noisy', 'a').
question(5, 'Which of these do you need when playing Monopoly?', 'Ball', 'Skipping Rope', 'Dice', 'Net', 'c').
question(5, 'Who starred in the 2003 comedy "School of Rock"?', 'Dean Green', 'Lou Blue', 'Jack Black', 'Jay Grey', 'c').
question(5, 'Which of these is not a term associated with poker?', 'Full House', 'Three of a Kind', 'Checkmate', 'Flush', 'c').
question(5, 'Which is the only country that shares a land border with Portugal?', 'France', 'Italy', 'Spain', 'Germany', 'c').
question(5, 'Which of these dates is St Valentine''s Day?', '14th June', '14th November', '14th February', '14th March', 'c').
question(5, 'Which of these chemical elements is not a metal?', 'Iron', 'Tin', 'Copper', 'Helium', 'd').

% --- LEVEL 6 ($2,000) ADDITIONS ---
question(6, 'What is the name of the wrinkles at the corner of someone''s eyes?', 'Crow''s Eggs', 'Crow''s Feathers', 'Crow''s Beaks', 'Crow''s Feet', 'd').
question(6, 'Which of these is an Olympic field event?', 'Shot Pitch', 'Shot Toss', 'Shot Put', 'Shot Set', 'c').
question(6, 'Which of these is a Bird of prey?', 'Vole', 'Vixen', 'Vulture', 'Viper', 'c').
question(6, 'Which phrase refers to a conventional postal system?', 'Snail Mail', 'Slug Dispatch', 'Tortoise Post', 'Turtle Fax', 'a').
question(6, 'Which of these is a term for an economic slump?', 'Expression', 'Depression', 'Compression', 'Impression', 'b').
question(6, 'What kind of policy might cover fire and theft?', 'Defiance', 'Insurance', 'Grievance', 'Romance', 'b').
question(6, 'Which of these is a swimming stroke?', 'Crawl', 'Slink', 'Creep', 'Slither', 'a').
question(6, 'The River Tagus flows into the Atlantic Ocean near which city?', 'Lisbon', 'Porto', 'Coimbra', 'Setubal', 'a').

% --- LEVEL 7 ($5,000) ADDITIONS ---
question(7, 'In Rossini''s Seville-based opera, what is the occupation of Figaro?', 'Barber', 'Butcher', 'Baker', 'Candlestick Maker', 'a').
question(7, 'Which of these events takes place at the Brickyard?', 'Indianapolis 500', 'US Open', 'World Series', 'Super Bowl', 'a').
question(7, 'What was the title of the rapper Eminem''s debut film?', '6 Inch', '2 Feet', '8 Mile', '10 Yards', 'c').
question(7, 'What name is given to someone who plays the flute?', 'Fluterman', 'Flutter', 'Fluteer', 'Flautist', 'd').
question(7, 'Which of these is a popular ballroom dance?', 'Wolfhop', 'Stoatskip', 'Bunnyjump', 'Foxtrot', 'd').
question(7, 'Who was the first King of Portugal?', 'Afonso Henriques', 'King Dinis', 'Vasco da Gama', 'Prince Henry', 'a').
question(7, 'What private eye character was created by Mickey Spillane?', 'Mike Saw', 'Mike Hammer', 'Mike Chisel', 'Mike Wrench', 'b').
question(7, 'Arches, loops and whorls are classifications of what?', 'Eyes', 'Fingerprints', 'Hair', 'Tastebuds', 'b').

% --- LEVEL 8 ($10,000) ADDITIONS ---
question(8, 'What kind of restaurant is likely to serve polenta?', 'Italian', 'Chinese', 'Turkish', 'Indian', 'a').
question(8, 'What nationality was the author of the novel "The Three Musketeers"?', 'Swiss', 'French', 'Italian', 'Spanish', 'b').
question(8, 'What is the traditional Portuguese custard tart called?', 'Pastel de Nata', 'Churro', 'Baklava', 'Croissant', 'a').
question(8, 'In which of these sports would you use a cue to hit the ball?', 'Tennis', 'Football', 'Hockey', 'Billiards', 'd').
question(8, 'Which of these words means "a summary or outline of a book"?', 'Synergy', 'Synod', 'Synopsis', 'Syntax', 'c').
question(8, 'To which of these pop groups did singer Sting belong?', 'U2', 'Boomtown Rats', 'Police', 'Genesis', 'c').
question(8, 'Which of these words refers to throwing something overboard from a ship or aeroplane?', 'Garrison', 'Frisson', 'Jettison', 'Chanson', 'c').
question(8, 'In the Harry Potter stories, what kind of creature is Firenze?', 'Dragon', 'Centaur', 'Phoenix', 'Owl', 'b').

% --- LEVEL 9 ($20,000) ADDITIONS ---
question(9, 'Which natural phenomenon is a display of the visible spectrum?', 'Hailstone', 'Eclipse', 'Sunbeam', 'Rainbow', 'd').
question(9, 'Which of these is a division of geological time?', 'Neon', 'Eon', 'Ion', 'Scion', 'b').
question(9, 'Which word is represented by the sign known as an ampersand?', 'Approximately', 'At', 'About', 'And', 'd').
question(9, 'How many points are scored for hitting the inner bull''s-eye in a game of darts?', '20', '40', '50', '100', 'c').
question(9, 'Which actor played the title role in Batman Begins, released in 2005?', 'Jake Gyllenhaal', 'Christian Bale', 'Wes Bentley', 'Mark Wahlberg', 'b').
question(9, 'Bolivia is a country in which continent?', 'South America', 'Africa', 'Asia', 'Europe', 'a').
question(9, 'Born in 1811, the Hungarian composer and pianist Liszt had what first name?', 'Felipe', 'Fritz', 'Ferdinand', 'Franz', 'd').
question(9, 'Which of these would you need for a pet Saluki?', 'Aquarium', 'Aviary', 'Dog Bed', 'Rabbit Hutch', 'c').

% --- LEVEL 10 ($50,000) ADDITIONS ---
question(10, 'Which musical genre is listed as UNESCO Intangible Cultural Heritage of Portugal?', 'Samba', 'Flamenco', 'Fado', 'Tango', 'c').
question(10, 'Complete the title of Gareth Brooks'' album Ropin'' the...what?', 'Steer', 'Hog', 'Corral', 'Wind', 'd').
question(10, 'The musical Evita is set in which country?', 'Mexico', 'Brazil', 'Argentina', 'Chile', 'c').
question(10, 'Which of these words does not feature in the title of a Shakespeare play?', 'Merchant', 'Wives', 'King', 'Queen', 'd').
question(10, 'Which company created the first portable CD player, the Discman?', 'Panasonic', 'Sony', 'Hitachi', 'Casio', 'b').
question(10, 'Who links the films Con Air, 8MM and Moonstruck?', 'Russell Crowe', 'Mel Gibson', 'Tom Cruise', 'Nicolas Cage', 'd').
question(10, 'The femur is a bone in which part of the human body?', 'Arm', 'Head', 'Leg', 'Hand', 'c').
question(10, 'Which of these rivers flows in a generally northward direction?', 'Volga', 'Rhone', 'Mississippi', 'Nile', 'd').

% --- LEVEL 11 ($75,000) ADDITIONS ---
question(11, 'In Japanese costume, what is an obi?', 'Sandal', 'Sash', 'Robe', 'Hat', 'b').
question(11, 'What are the main colors of the Portuguese flag?', 'Blue and White', 'Green and Red', 'Yellow and Red', 'Green and White', 'b').
question(11, 'Which car company manufactures the Passat?', 'Nissan', 'Volkswagen', 'Toyota', 'BMW', 'b').
question(11, 'Which of these musicians had the middle name Aaron?', 'Elvis Presley', 'Jimi Hendrix', 'John Lennon', 'Michael Jackson', 'a').
question(11, 'What type of creature is a marmoset?', 'Whale', 'Butterfly', 'Monkey', 'Parrot', 'c').
question(11, 'An oologist is an expert in what?', 'Wine', 'Birds Eggs', 'Foreign Words', 'Jupiter', 'b').
question(11, 'Which island country was formerly called Ceylon?', 'Iceland', 'Madagascar', 'Taiwan', 'Sri Lanka', 'd').
question(11, 'Brothers Leon and Michael Spinks were champions in which sport?', 'Golf', 'Hockey', 'Boxing', 'Basketball', 'c').

% --- LEVEL 12 ($150,000) ADDITIONS ---
question(12, 'The Douro Valley is world-famous for the production of which beverage?', 'Champagne', 'Whisky', 'Port Wine', 'Tequila', 'c').
question(12, 'Which spirit is the basis of a mai tai cocktail?', 'Gin', 'Rum', 'Whisky', 'Vodka', 'b').
question(12, 'In which city was the prophet Muhammed born?', 'Jerusalem', 'Medina', 'Mecca', 'Damascus', 'c').
question(12, 'Which of these is a plant with edible leaves?', 'French Chard', 'Swiss Chard', 'Belgian Chard', 'Norwegian Chard', 'b').
question(12, 'With which of these drinks is Stilton cheese traditionally served?', 'Port', 'Vodka', 'Champagne', 'Gin', 'a').
question(12, 'What was the profession of the 17th-century figure, Moliere?', 'Violin Maker', 'Opera Singer', 'Ballet Dancer', 'Playwright', 'd').
question(12, 'Which type of instrument is a marimba?', 'Keyboard', 'Brass', 'Woodwind', 'Percussion', 'd').
question(12, 'A person suffering from which condition would have most need of drugs called bronchodilators?', 'Sinusitis', 'Eczema', 'Asthma', 'Diabetes', 'c').

% --- LEVEL 13 ($250,000) ADDITIONS ---
question(13, 'Which Portuguese explorer was the first to reach India by sea?', 'Columbus', 'Magellan', 'Vasco da Gama', 'Cabral', 'c').
question(13, 'Who wrote the children''s story "How the Leopard Got His Spots"?', 'Hans Christian Anderson', 'Rudyard Kipling', 'Edward Lear', 'Lewis Carroll', 'b').
question(13, 'The city of Timbuktu stands close to the bank of which river?', 'Nile', 'Congo', 'Niger', 'Zambezi', 'c').
question(13, 'Which country ruled Finland between 1809 and 1917?', 'Russia', 'Norway', 'Britain', 'Germany', 'a').
question(13, 'On which continent is the Istria peninsular?', 'Asia', 'Africa', 'Europe', 'South America', 'c').
question(13, 'In chemistry, which of these is a non-metallic element?', 'Manganese', 'Chromium', 'Phosphorus', 'Nickel', 'c').
question(13, 'In the animal world, the two types of monotreme are the echidna and what?', 'Wombat', 'Possum', 'Platypus', 'Bandicoot', 'c').

% --- LEVEL 14 ($500,000) ADDITIONS ---
question(14, 'Sir John Oldcastle is believed to be the prototype for which of Shakespeare''s characters?', 'Macbeth', 'Falstaff', 'Prospero', 'Cymbeline', 'b').
question(14, 'In which city did the poet John Keats die?', 'Copenhagen', 'Brussels', 'Rome', 'Vienna', 'c').
question(14, 'In mythology, Orpheous played which instrument?', 'Lyre', 'Flute', 'Organ', 'Pan pipes', 'a').
question(14, 'Reiki is a healing technique from which country?', 'China', 'Japan', 'India', 'Thailand', 'b').
question(14, 'Orvieto wine comes from which country?', 'France', 'Spain', 'Germany', 'Italy', 'd').
question(14, 'Who wrote the Portuguese national epic "Os Lusiadas"?', 'Fernando Pessoa', 'Jose Saramago', 'Eca de Queiros', 'Luis de Camoes', 'd').
question(14, 'In Germany, what kind of building is the Rathaus?', 'Cathedral', 'Hospital', 'Town Hall', 'Police Station', 'c').
question(14, 'Which singer launched her own label, Matriarch Records, in 2004?', 'Mary J Blige', 'Madonna', 'Mariah Carey', 'Mandy Moore', 'a').

% --- LEVEL 15 ($1,000,000) ADDITIONS ---
question(15, 'Which compass point lies midway between east and north-east?', 'East-north-east', 'North-east-north', 'East-east-north', 'North-north-east', 'a').
question(15, 'Who wrote the novel "The Turn of the Screw"?', 'EM Foster', 'Christopher Isherwood', 'Henry James', 'John Galsworthy', 'c').
question(15, 'The "K" point is a measurement used in which sport?', 'Triple Jump', 'Curling', 'Rifle Shooting', 'Ski Jumping', 'd').
question(15, 'In the Roman Catholic Church, what is a monstrance?', 'Priest''s robe', 'Ritual container', 'Altar cloth', 'Prayer', 'b').
question(15, 'Discovery is a variety of which fruit?', 'Apple', 'Banana', 'Plum', 'Strawberry', 'a').
question(15, 'The heaviest bird of prey is what kind of bird?', 'Hawk', 'Owl', 'Condor', 'Kestrel', 'c').
question(15, 'In which year did the Carnation Revolution take place in Portugal?', '1970', '1974', '1980', '1968', 'b').
question(15, 'Which of these conditions is caused by a deficiency in B1?', 'Rickets', 'Scurvy', 'Beriberi', 'Malaria', 'c').
*/