# Import the required libraries
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

# Specify the URL of the YouTube video you want to scrape
video_url = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"

# Create a new instance of the Chrome web driver
driver = webdriver.Chrome()

# Open the YouTube video page
driver.get(video_url)

# Wait for the video player element to be loaded on the page
video_player = WebDriverWait(driver, 10).until(
    EC.presence_of_element_located((By.ID, "movie_player"))
)

# Get the current time and duration of the video using the execute_script method of the WebDriver class
current_time = driver.execute_script("return arguments[0].getCurrentTime();", video_player)
duration = driver.execute_script("return arguments[0].getDuration();", video_player)
print(current_time)
print(duration)
# Calculate the percentage of the video that has been played
percent_played = current_time / duration * 100

# Check if an ad is being played by checking if the percentage played is less than 100
if percent_played < 100:
  print("An ad is being played.")
else:
  print("No ad is being played.")

# Close the web driver
driver.close()
