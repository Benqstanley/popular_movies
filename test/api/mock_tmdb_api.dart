import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:popular_movies/api/tmdb_api.dart';
import 'package:popular_movies/model/fetch_movies_response.dart';
import 'package:popular_movies/model/movie_overview.dart';

class MockTMBDAPI extends Mock implements TMDBAPI {
  MockTMBDAPI();

  static String discoverResponse =
      """{"page":1,"total_results":10000,"total_pages":500,"results":[{"popularity":2931.926,"vote_count":151,"video":false,"poster_path":"\/7D430eqZj8y3oVkLFfsWXGRcpEG.jpg","id":528085,"adult":false,"backdrop_path":"\/5UkzNSOK561c2QRy2Zr4AkADzLT.jpg","original_language":"en","original_title":"2067","genre_ids":[18,878,53],"title":"2067","vote_average":5.8,"overview":"A lowly utility worker is called to the future by a mysterious radio signal, he must leave his dying wife to embark on a journey that will force him to face his deepest fears in an attempt to change the fabric of reality and save humankind from its greatest environmental crisis yet.","release_date":"2020-10-01"},{"popularity":1615.119,"vote_count":117,"video":false,"poster_path":"\/elZ6JCzSEvFOq4gNjNeZsnRFsvj.jpg","id":741067,"adult":false,"backdrop_path":"\/aO5ILS7qnqtFIprbJ40zla0jhpu.jpg","original_language":"en","original_title":"Welcome to Sudden Death","genre_ids":[28,12,18,53],"title":"Welcome to Sudden Death","vote_average":6.6,"overview":"Jesse Freeman is a former special forces officer and explosives expert now working a regular job as a security guard in a state-of-the-art basketball arena. Trouble erupts when a tech-savvy cadre of terrorists kidnap the team's owner and Jesse's daughter during opening night. Facing a ticking clock and impossible odds, it's up to Jesse to not only save them but also a full house of fans in this highly charged action thriller.","release_date":"2020-09-29"},{"popularity":1262.157,"vote_count":2146,"video":false,"poster_path":"\/riYInlsq2kf1AWoGm80JQW5dLKp.jpg","id":497582,"adult":false,"backdrop_path":"\/kMe4TKMDNXTKptQPAdOF0oZHq3V.jpg","original_language":"en","original_title":"Enola Holmes","genre_ids":[80,18,9648],"title":"Enola Holmes","vote_average":7.6,"overview":"While searching for her missing mother, intrepid teen Enola Holmes uses her sleuthing skills to outsmart big brother Sherlock and help a runaway lord.","release_date":"2020-09-23"},{"popularity":870.005,"vote_count":145,"video":false,"poster_path":"\/ugZW8ocsrfgI95pnQ7wrmKDxIe.jpg","id":724989,"adult":false,"backdrop_path":"\/86L8wqGMDbwURPni2t7FQ0nDjsH.jpg","original_language":"en","original_title":"Hard Kill","genre_ids":[28,53],"title":"Hard Kill","vote_average":4.7,"overview":"The work of billionaire tech CEO Donovan Chalmers is so valuable that he hires mercenaries to protect it, and a terrorist group kidnaps his daughter just to get it.","release_date":"2020-08-25"},{"popularity":868.324,"vote_count":2556,"video":false,"poster_path":"\/aKx1ARwG55zZ0GpRvU2WrGrCG9o.jpg","id":337401,"adult":false,"backdrop_path":"\/zzWGRw277MNoCs3zhyG3YmYQsXv.jpg","original_language":"en","original_title":"Mulan","genre_ids":[28,12,18,14],"title":"Mulan","vote_average":7.3,"overview":"When the Emperor of China issues a decree that one man per family must serve in the Imperial Chinese Army to defend the country from Huns, Hua Mulan, the eldest daughter of an honored warrior, steps in to take the place of her ailing father. She is spirited, determined and quick on her feet. Disguised as a man by the name of Hua Jun, she is tested every step of the way and must harness her innermost strength and embrace her true potential.","release_date":"2020-09-04"},{"popularity":826.627,"vote_count":150,"video":false,"poster_path":"\/6CoRTJTmijhBLJTUNoVSUNxZMEI.jpg","id":694919,"adult":false,"backdrop_path":"\/pq0JSpwyT2URytdFG0euztQPAyR.jpg","original_language":"en","original_title":"Money Plane","genre_ids":[28],"title":"Money Plane","vote_average":5.9,"overview":"A professional thief with \$40 million in debt and his family's life on the line must commit one final heist - rob a futuristic airborne casino filled with the world's most dangerous criminals.","release_date":"2020-09-29"},{"popularity":792.863,"vote_count":44,"video":false,"poster_path":"\/5aL71e0XBgHZ6zdWcWeuEhwD2Gw.jpg","id":721656,"adult":false,"backdrop_path":"\/5gTQmnGYKxDfmUWJ9GUWqrszRxN.jpg","original_language":"en","original_title":"Happy Halloween Scooby-Doo!","genre_ids":[16,35,80,9648,10751],"title":"Happy Halloween Scooby-Doo!","vote_average":7.8,"overview":"Scooby-Doo and the gang team up with their pals, Bill Nye The Science Guy and Elvira Mistress of the Dark, to solve this mystery of gigantic proportions and save Crystal Cove!","release_date":"2020-10-06"},{"popularity":742.802,"vote_count":7,"video":false,"poster_path":"\/h8Rb9gBr48ODIwYUttZNYeMWeUU.jpg","id":635302,"adult":false,"backdrop_path":"\/xoqr4dMbRJnzuhsWDF3XNHQwJ9x.jpg","original_language":"ja","original_title":"劇場版「鬼滅の刃」無限列車編","genre_ids":[28,12,16,18,14,36],"title":"Demon Slayer: Kimetsu no Yaiba - The Movie: Mugen Train","vote_average":8.3,"overview":"Tanjirō Kamado, joined with Inosuke Hashibira, a boy raised by boars who wears a boar's head, and Zenitsu Agatsuma, a scared boy who reveals his true power when he sleeps, boards the Infinity Train on a new mission with the Fire Hashira, Kyōjurō Rengoku, to defeat a demon who has been tormenting the people and killing the demon slayers who oppose it!","release_date":"2020-10-16"},{"popularity":730.904,"vote_count":92,"video":false,"poster_path":"\/xqvX5A24dbIWaeYsMTxxKX5qOfz.jpg","id":660982,"adult":false,"backdrop_path":"\/75ooojtgiKYm5LcCczbCexioZze.jpg","original_language":"en","original_title":"American Pie Presents: Girls' Rules","genre_ids":[35],"title":"American Pie Presents: Girls Rules","vote_average":6.6,"overview":"It's Senior year at East Great Falls. Annie, Kayla, Michelle, and Stephanie decide to harness their girl power and band together to get what they want their last year of high school.","release_date":"2020-10-06"},{"popularity":715.29,"vote_count":310,"video":false,"poster_path":"\/uOw5JD8IlD546feZ6oxbIjvN66P.jpg","id":718444,"adult":false,"backdrop_path":"\/x4UkhIQuHIJyeeOTdcbZ3t3gBSa.jpg","original_language":"en","original_title":"Rogue","genre_ids":[28],"title":"Rogue","vote_average":5.9,"overview":"Battle-hardened O’Hara leads a lively mercenary team of soldiers on a daring mission: rescue hostages from their captors in remote Africa. But as the mission goes awry and the team is stranded, O’Hara’s squad must face a bloody, brutal encounter with a gang of rebels.","release_date":"2020-08-20"},{"popularity":676.927,"vote_count":6,"video":false,"poster_path":"\/z0r3YjyJSLqf6Hz0rbBAnEhNXQ7.jpg","id":697064,"adult":false,"backdrop_path":"\/7WKIOXJa2JjHygE8Yta3uaCv6GC.jpg","original_language":"en","original_title":"Beckman","genre_ids":[28],"title":"Beckman","vote_average":5.4,"overview":"A contract killer, becomes the reverend of a LA church, until a cult leader and his minions kidnap his daughter. Blinded by vengeance, he cuts a bloody path across the city. The only thing that can stop him is his newfound faith.","release_date":"2020-09-10"},{"popularity":670.397,"vote_count":138,"video":false,"poster_path":"\/9Rj8l6gElLpRL7Kj17iZhrT5Zuw.jpg","id":734309,"adult":false,"backdrop_path":"\/7fvdg211A2L0mHddvzyArRuRalp.jpg","original_language":"en","original_title":"Santana","genre_ids":[28,18,53],"title":"Santana","vote_average":5.6,"overview":"Two brothers — one a narcotics agent and the other a general — finally discover the identity of the drug lord who murdered their parents decades ago. They may kill each other before capturing the bad guys.","release_date":"2020-08-28"},{"popularity":653.73,"vote_count":504,"video":false,"poster_path":"\/qzA87Wf4jo1h8JMk9GilyIYvwsA.jpg","id":539885,"adult":false,"backdrop_path":"\/54yOImQgj8i85u9hxxnaIQBRUuo.jpg","original_language":"en","original_title":"Ava","genre_ids":[28,80,18,53],"title":"Ava","vote_average":5.9,"overview":"A black ops assassin is forced to fight for her own survival after a job goes dangerously wrong.","release_date":"2020-07-02"},{"popularity":652.72,"vote_count":634,"video":false,"poster_path":"\/sy6DvAu72kjoseZEjocnm2ZZ09i.jpg","id":581392,"adult":false,"backdrop_path":"\/2nFzxaAK7JIsk6l7qZ8rFBsa3yW.jpg","original_language":"ko","original_title":"반도","genre_ids":[28,27,53],"title":"Peninsula","vote_average":7.1,"overview":"A soldier and his team battle hordes of post-apocalyptic zombies in the wastelands of the Korean Peninsula.","release_date":"2020-07-15"},{"popularity":578.561,"vote_count":439,"video":false,"poster_path":"\/zGVbrulkupqpbwgiNedkJPyQum4.jpg","id":592350,"adult":false,"backdrop_path":"\/9guoVF7zayiiUq5ulKQpt375VIy.jpg","original_language":"ja","original_title":"僕のヒーローアカデミア THE MOVIE ヒーローズ：ライジング","genre_ids":[28,16],"title":"My Hero Academia: Heroes Rising","vote_average":8.6,"overview":"Class 1-A visits Nabu Island where they finally get to do some real hero work. The place is so peaceful that it's more like a vacation … until they're attacked by a villain with an unfathomable Quirk! His power is eerily familiar, and it looks like Shigaraki had a hand in the plan. But with All Might retired and citizens' lives on the line, there's no time for questions. Deku and his friends are the next generation of heroes, and they're the island's only hope.","release_date":"2019-12-20"},{"popularity":539.829,"vote_count":884,"video":false,"poster_path":"\/tI8ocADh22GtQFV28vGHaBZVb0U.jpg","id":475430,"adult":false,"backdrop_path":"\/o0F8xAt8YuEm5mEZviX5pEFC12y.jpg","original_language":"en","original_title":"Artemis Fowl","genre_ids":[28,12,14,878,10751],"title":"Artemis Fowl","vote_average":5.8,"overview":"Artemis Fowl is a 12-year-old genius and descendant of a long line of criminal masterminds. He soon finds himself in an epic battle against a race of powerful underground fairies who may be behind his father's disappearance.","release_date":"2020-06-12"},{"popularity":535.058,"vote_count":220,"video":false,"poster_path":"\/vJHSParlylICnI7DuuI54nfTPRR.jpg","id":438396,"adult":false,"backdrop_path":"\/qGZe9qTuydxyJYQ60XDtEckzLR8.jpg","original_language":"es","original_title":"Orígenes secretos","genre_ids":[18,53],"title":"Unknown Origins","vote_average":6.2,"overview":"In Madrid, Spain, a mysterious serial killer ruthlessly murders his victims by recreating the first appearance of several comic book superheroes. Cosme, a veteran police inspector who is about to retire, works on the case along with the tormented inspector David Valentín and his own son Jorge Elías, a nerdy young man who owns a comic book store.","release_date":"2020-08-28"},{"popularity":520.614,"vote_count":102,"video":false,"poster_path":"\/r4Lm1XKP0VsTgHX4LG4syAwYA2I.jpg","id":590223,"adult":false,"backdrop_path":"\/lA5fOBqTOQBQ1s9lEYYPmNXoYLi.jpg","original_language":"en","original_title":"Love and Monsters","genre_ids":[12,35,878,10749],"title":"Love and Monsters","vote_average":7.7,"overview":"Seven years after the Monsterpocalypse, Joel Dawson, along with the rest of humanity, has been living underground ever since giant creatures took control of the land. After reconnecting over radio with his high school girlfriend Aimee, who is now 80 miles away at a coastal colony, Joel begins to fall for her again. As Joel realizes that there’s nothing left for him underground, he decides against all logic to venture out to Aimee, despite all the dangerous monsters that stand in his way.","release_date":"2020-10-16"},{"popularity":484.417,"vote_count":143,"video":false,"poster_path":"\/eDnHgozW8vfOaLHzfpHluf1GZCW.jpg","id":606234,"adult":false,"backdrop_path":"\/u9YEh2xVAPVTKoaMNlB5tH6pXkm.jpg","original_language":"en","original_title":"Archive","genre_ids":[18,14,878,53],"title":"Archive","vote_average":5.6,"overview":"2038: George Almore is working on a true human-equivalent AI, and his latest prototype is almost ready. This sensitive phase is also the riskiest as he has a goal that must be hidden at all costs—being reunited with his dead wife.","release_date":"2020-08-13"},{"popularity":474.368,"vote_count":451,"video":false,"poster_path":"\/kPzcvxBwt7kEISB9O4jJEuBn72t.jpg","id":677638,"adult":false,"backdrop_path":"\/pO1SnM5a1fEsYrFaVZW78Wb0zRJ.jpg","original_language":"en","original_title":"We Bare Bears: The Movie","genre_ids":[12,16,35,9648,10751],"title":"We Bare Bears: The Movie","vote_average":7.7,"overview":"When Grizz, Panda, and Ice Bear's love of food trucks and viral videos went out of hand, it catches the attention of Agent Trout from the National Wildlife Control, who pledges to restore the “natural order” by separating them forever. Chased away from their home, the Bears embark on an epic road trip as they seek refuge in Canada, with their journey being filled with new friends, perilous obstacles, and huge parties. The risky journey also forces the Bears to face how they first met and became brothers, in order to keep their family bond from splitting apart.","release_date":"2020-06-30"}]}""";
  static String searchResponse = """{
  "page": 1,
  "total_results": 2,
  "total_pages": 1,
  "results": [
    {
      "popularity": 28.15,
      "id": 75780,
      "video": false,
      "vote_count": 4904,
      "vote_average": 6.5,
      "title": "Jack Reacher",
      "release_date": "2012-12-20",
      "original_language": "en",
      "original_title": "Jack Reacher",
      "genre_ids": [
        80,
        18,
        53,
        28
      ],
      "backdrop_path": "/k7h4RNAarfOrF2r2YMN0P2FQSr4.jpg",
      "adult": false,
      "overview": "When a gunman takes five lives with six shots, all evidence points to the suspect in custody. On interrogation, the suspect offers up a single note: 'Get Jack Reacher!' So begins an extraordinary chase for the truth, pitting Jack Reacher against an unexpected enemy, with a skill for violence and a secret to keep.",
      "poster_path": "/zlyhKMi2aLk25nOHnNm43MpZMtQ.jpg"
    },
    {
      "popularity": 26.683,
      "vote_count": 3330,
      "video": false,
      "poster_path": "/heHPL3kGWy4pMGkSg2g9Nd5QT4C.jpg",
      "id": 343611,
      "adult": false,
      "backdrop_path": "/ww1eIoywghjoMzRLRIcbJLuKnJH.jpg",
      "original_language": "en",
      "original_title": "Jack Reacher: Never Go Back",
      "genre_ids": [
        28,
        53
      ],
      "title": "Jack Reacher: Never Go Back",
      "vote_average": 5.7,
      "overview": "Jack Reacher must uncover the truth behind a major government conspiracy in order to clear his name. On the run as a fugitive from the law, Reacher uncovers a potential secret from his past that could change his life forever.",
      "release_date": "2016-10-19"
    }
  ]
}""";
  static Map<String, dynamic> discoverMap = json.decode(discoverResponse);
  static Map<String, dynamic> searchMap = json.decode(searchResponse);

  static List<MovieOverview> discoverList =
      (discoverMap["results"] as List<dynamic>).map<MovieOverview>((movieMap) {
    return MovieOverview.fromJson(movieMap);
  }).toList();
  static List<MovieOverview> searchList =
      (searchMap["results"] as List<dynamic>).map<MovieOverview>((movieMap) {
    return MovieOverview.fromJson(movieMap);
  }).toList();

  factory MockTMBDAPI.success() {
    var api = MockTMBDAPI();
    when(api.fetchPopularMovies(any)).thenAnswer((realInvocation) async {
      return FetchMoviesResponse(
        popularMovies: discoverList,
        total: 20,
      );
    });
    when(api.search(any)).thenAnswer((realInvocation) async => searchList);
    return api;
  }

  factory MockTMBDAPI.successOnce() {
    int i = 0;
    var api = MockTMBDAPI();
    when(api.fetchPopularMovies(any)).thenAnswer((realInvocation) async {
      i++;
      return i == 1 ? FetchMoviesResponse(
        popularMovies: discoverList,
        total: 20,
      ) : null;
    });
    when(api.search(any)).thenAnswer((realInvocation) async => searchList);
    return api;
  }

  factory MockTMBDAPI.failure() {
    var api = MockTMBDAPI();
    when(api.fetchPopularMovies(any)).thenAnswer((realInvocation) async {
      return null;
    });
    when(api.search(any)).thenAnswer((realInvocation) async => null);
    return api;
  }
}
