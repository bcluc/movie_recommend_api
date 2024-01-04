#
# This is a Plumber API. You can run the API by clicking
# the 'Run API' button above.
#
# Find out more about building APIs with Plumber here:
#
#    https://www.rplumber.io/
#

library(plumber)
options("plumber.port" = 5555)

movie_filter = readRDS("movieRecModel.rds")

#* @apiTitle Recommendation System for Film
#* @apiDescription Return top 5 movie that revelant to input movie

#*@param movie The movie to echo
#*@get /recommend
function(movie){
  director <- movies_filter$director[movies_filter$id==movie]
  actor1 <- movies_filter$actor_1[movies_filter$id==movie]
  actor2 <- movies_filter$actor_2[movies_filter$id==movie]
  actor3 <- movies_filter$actor_3[movies_filter$id==movie]
  genre1 <- movies_filter$genre_1[movies_filter$id==movie]
  genre2 <- movies_filter$genre_2[movies_filter$id==movie]
  genre3 <- movies_filter$genre_3[movies_filter$id==movie]
  
  rec_df <- movies_filter
  
  rec_df$same_director <- NA
  rec_df$same_a1 <- NA
  rec_df$same_a2 <- NA
  rec_df$same_a3 <- NA
  rec_df$same_g1 <- NA
  rec_df$same_g2 <- NA
  rec_df$same_g3 <- NA
  
  rec_df$same_director <- ifelse(rec_df$director==director, 1, 0)
  rec_df$same_a1 <- ifelse(rec_df$actor_1==actor1|rec_df$actor_2==actor1|rec_df$actor_3==actor1, 1, 0)
  rec_df$same_a2 <- ifelse(rec_df$actor_1==actor2|rec_df$actor_2==actor2|rec_df$actor_3==actor2, 1, 0)
  rec_df$same_a3 <- ifelse(rec_df$actor_1==actor3|rec_df$actor_2==actor3|rec_df$actor_3==actor3, 1, 0)
  rec_df$same_g1 <- ifelse(rec_df$genre_1==genre1|rec_df$genre_2==genre1|rec_df$genre_3==genre1, 1, 0)
  rec_df$same_g2 <- ifelse(rec_df$genre_1==genre2|rec_df$genre_2==genre2|rec_df$genre_3==genre2, 1, 0)
  rec_df$same_g3 <- ifelse(rec_df$genre_1==genre3|rec_df$genre_2==genre3|rec_df$genre_3==genre3, 1, 0)
  
  rec_df <- rec_df %>% mutate_at(vars("same_director": "same_g3"), list(~replace(., is.na(.), 0)))
  
  rec_df$sim_count <- rowSums(rec_df[,10:16])
  
  rec_df <- left_join(rec_df, movies %>% select(id, weighted_rating), by="id")
  
  Top5_rec <- rec_df %>% arrange(desc(sim_count), desc(weighted_rating)) %>% slice(1:6) %>% select(id, title, sim_count, weighted_rating, everything())
  
  return(Top5_rec)
}