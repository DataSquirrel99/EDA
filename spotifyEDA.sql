USE project1;
select count(*) from spotify2023;

-- most and least number of streams
select max(streams), min(streams) from spotify2023;

-- most streamed song
select track_name, `artist(s)_name`, streams from spotify2023 
where streams=(select max(streams) from spotify2023);

-- least streamed song
select track_name, `artist(s)_name`, streams from spotify2023 
where streams=(select min(streams) from spotify2023 where streams<>0);

-- songs in chronological order
select track_name, `artist(s)_name`, streams, released_day,released_month,released_year from spotify2023 
order by released_year, released_month, released_day;

-- most streamed colab song
select track_name, `artist(s)_name`, streams from spotify2023 
where streams=(select max(streams) from spotify2023 where artist_count>1);

-- songs over 1 billion streams
select track_name, `artist(s)_name`, streams from spotify2023 
where streams>999999999 order by streams;

-- top 10 songs with the most streams
select track_name, `artist(s)_name`, streams from spotify2023 
order by streams desc limit 10;

-- top songs released in 2023
select track_name, `artist(s)_name`, streams from spotify2023 
where released_year=2023
order by streams desc;

-- top songs released in 2023 with no colaboration
select track_name, `artist(s)_name`, streams from spotify2023 
where released_year=2023 and artist_count=1
order by streams desc;

-- top songs released in 2022
select track_name, `artist(s)_name`, streams from spotify2023 
where released_year=2022
order by streams desc;

-- top songs released in 2021
select track_name, `artist(s)_name`, streams from spotify2023 
where released_year=2021
order by streams desc;

-- top songs released in 2020 and the previous years
select track_name, `artist(s)_name`, streams, released_year from spotify2023 
where released_year<2021
order by streams desc;

-- most streamed artist without including colab sreams
select `artist(s)_name`,sum(streams) as stream from spotify2023 
where artist_count<2
group by `artist(s)_name` 
order by stream desc;

-- most streamed song of the most streamed artist from the top songs of 2023
select `artist(s)_name`,track_name as track from spotify2023 
where `artist(s)_name` like '%taylor%'
order by streams desc;

-- total number of streams of thr most streamed artist (including colabs)
select sum(streams) from spotify2023 
where `artist(s)_name` like '%taylor%';

-- songs that were listed in the most number of spotify playlists
select track_name, `artist(s)_name`, in_spotify_playlists from spotify2023 
order by in_spotify_playlists desc limit 10;

-- songs that were listed in the most number of apple playlists
select track_name, `artist(s)_name`, in_apple_playlists from spotify2023 
order by in_apple_playlists desc limit 10;

-- songs that were listed in the most number of deezer playlists
select track_name, `artist(s)_name`, (in_deezer_playlists+0)  from spotify2023 
order by (in_deezer_playlists+0) desc limit 10;

-- songs that were listed in the most number of playlists
select track_name, `artist(s)_name`, (in_spotify_playlists+in_apple_playlists+in_deezer_playlists) as playlists from spotify2023 
order by playlists desc limit 10;

-- low energy dance songs
select track_name, `artist(s)_name` from spotify2023 
where `danceability_%`>80 and `energy_%`<50 ;

-- edm songs
select track_name, `artist(s)_name` from spotify2023 
where `instrumentalness_%` > (select avg(`instrumentalness_%`) from spotify2023 ) 
and `danceability_%`>(select avg(`danceability_%`) from spotify2023 ) 
and `energy_%`>(select avg(`energy_%`) from spotify2023);

-- rap songs 
select track_name, `artist(s)_name`,`speechiness_%` from spotify2023 
where `speechiness_%`>23;

-- tracks with the ideal BPM for cpr
select track_name,`artist(s)_name` from spotify2023
where bpm>99 and bpm<121;

-- count of songs charted and not charted
select chart_status, count(chart_status) as chart_status_count from (select case
when in_spotify_charts>0 then "charted"
when in_apple_charts>0 then "charted"
when in_deezer_charts>0 then "charted"
when in_shazam_charts>0 then "charted" 
else "not charted" end as chart_status
from spotify2023) as chart group by chart_status;

-- most streamed songs that were not charted
select track_name,`artist(s)_name`, streams, case
when in_spotify_charts>0 then "charted"
when in_apple_charts>0 then "charted"
when in_deezer_charts>0 then "charted"
when in_shazam_charts>0 then "charted" 
else "not charted" end as chart_status
from spotify2023 
having chart_status="not charted"
order by streams desc limit 10;

-- songs that are only charted in shazam
select `artist(s)_name`,track_name,in_shazam_charts from spotify2023
where in_apple_charts=0 and in_spotify_charts=0 and in_deezer_charts=0 and in_shazam_charts>0
order by in_shazam_charts desc;

-- artists with the most songs in the top songs of 2023
select `artist(s)_name`, count(`artist(s)_name`) as artist_appearance from spotify2023 
group by `artist(s)_name`
order by artist_appearance desc limit 10;

-- most charted songs in 2023
select track_name, `artist(s)_name`, (in_spotify_charts+in_apple_charts+in_deezer_charts+in_shazam_charts) as in_charts from spotify2023
having in_charts>0
order by in_charts desc;

-- songs charted in all 4 platforms
select track_name,`artist(s)_name`, case
when in_spotify_charts>0 and in_apple_charts>0 and in_deezer_charts>0 and in_shazam_charts>0 then 4
when ((in_spotify_charts>0 and in_apple_charts>0 and in_deezer_charts>0) or (in_apple_charts>0 and in_deezer_charts>0 and in_shazam_charts>0) or (in_deezer_charts>0 and in_shazam_charts>0 and in_spotify_charts>0)) then 3
when ((in_spotify_charts>0 and in_apple_charts>0) or (in_apple_charts>0 and in_deezer_charts>0) or (in_deezer_charts>0 and in_shazam_charts>0) or (in_shazam_charts>0 and in_spotify_charts>0) or (in_deezer_charts>0 and  in_spotify_charts>0) or (in_apple_charts>0 and in_shazam_charts>0) ) then 2
when in_spotify_charts>0 or in_apple_charts>0 or in_deezer_charts>0 or in_shazam_charts>0 then 1
else 0
end as platforms_charted_in from spotify2023
having platforms_charted_in=4;

-- count of songs with the number of platforms charted
select platforms_charted_in,count(platforms_charted_in) from (select case
when in_spotify_charts>0 and in_apple_charts>0 and in_deezer_charts>0 and in_shazam_charts>0 then 4
when in_spotify_charts>0 and in_apple_charts>0 and in_deezer_charts>0 then 3
when in_apple_charts>0 and in_deezer_charts>0 and in_shazam_charts>0 then 3
when in_deezer_charts>0 and in_shazam_charts>0 and in_spotify_charts>0 then 3
when in_spotify_charts>0 and in_apple_charts>0 then 2
when in_apple_charts>0 and in_deezer_charts>0 then 2
when in_deezer_charts>0 and in_shazam_charts>0 then 2
when in_shazam_charts>0 and in_spotify_charts>0 then 2
when in_deezer_charts>0 and  in_spotify_charts>0 then 2
when in_apple_charts>0 and in_shazam_charts>0 then 2
when in_spotify_charts>0 or in_apple_charts>0 or in_deezer_charts>0 or in_shazam_charts>0 then 1
else 0
end as platforms_charted_in from spotify2023) as charted
group by platforms_charted_in;

-- songs charted in shazam (ordered by most to least shazamed songs)
select track_name, `artist(s)_name` from spotify2023
where in_shazam_charts>0
order by in_shazam_charts desc, streams desc;

-- songs charted in shazam but not in apple
select track_name, `artist(s)_name`, in_shazam_charts from spotify2023
where in_apple_charts=0 and in_shazam_charts>0;

-- songs in less than 100 playlists
select track_name,`artist(s)_name`,in_spotify_playlists,streams from spotify2023
where in_spotify_playlists<100
order by streams desc;

-- songs with the most colaboration
select track_name,`artist(s)_name`,artist_count from spotify2023
where artist_count=(select max(artist_count) from spotify2023);

-- keys listed from most to least used keys
select spotify2023.key,count(spotify2023.key) as key_count from spotify2023
group by spotify2023.key
order by key_count desc;

-- song with the highest bpm
select track_name, `artist(s)_name`,bpm from spotify2023
where bpm=(select max(bpm) from spotify2023);

-- dance song with the lowest bpm
select track_name, `artist(s)_name`,bpm from spotify2023
where bpm=(select min(bpm) from spotify2023 where `danceability_%`>80);
