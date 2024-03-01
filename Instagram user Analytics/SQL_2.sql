use ig_clone;
select*from users;
/*To Find the 5 oldest users of the Instagram from the database provided*/
select*from users order by created_at limit 5;

/*To  Find the users who have never posted a single photo on Instagram*/
select*from photos;
select username,image_url from users left join photos on users.id=photos.user_id where photos.id is null;

/*To Identify the winner of the contest and provide their details to the team*/
select*from likes;
select id,image_url,count(*) as total_likes from photos inner join likes on likes.photo_id=photos.id group by photos.id order by total_likes desc limit 1;

/*To find what day of the week do most users register on?*/
select dayname(created_at) as day, count(*) as total_registeration from users group by day order by total_registeration desc limit 2;

/*To Identify and suggest the top 5 most commonly used hashtags on the platform*/
select * from tags;
select * from photo_tags;
select tags.tag_name, count(*) as total_tags from photo_tags join tags on photo_tags.tag_id=tags.id group by tags.id order by total_tags desc limit 5;

/*To Provide data on users (bots) who have liked every single photo on the site (since any normal user would not be able to do this)*/
select username,count(*) as num_likes from users inner join likes on users.id=likes.user_id group by likes.user_id 
having num_likes=(select count(*) from photos);

/*To find out  how many times does average user posts on Instagram. Also  total number of photos on Instagram/total 
number of user*/
select count(*) from photos;
select count(*) from users;
select ((select count(*) from photos)/(select count(*) from users)) as avg_user;

