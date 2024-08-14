import React from "react";
import { Image } from "expo-image";
import { View, Text, StyleSheet, ImageBackground } from "react-native";

export default function HomeScreen() {
  return (
    <View
      style={{
        flex: 1,
        backgroundColor: "#EAF3FF",
      }}
    >
      <ImageBackground
        style={{ flex: 1, justifyContent: "center" }}
        resizeMode="cover"
        source={{
          uri: "https://pronft.netlify.app/static/media/banner.3c310352a6d940cab963.svg",
        }}
      >
        <View style={styles.container}>
          <View style={styles.textContainer}>
            <Text style={styles.title}>DaktarLamara App</Text>
            <Text style={styles.subtitle}>
              A mobile app for booking appointments with doctors.
            </Text>

            <View style={styles.iconContainer}>
              <Image
                source={{
                  uri: "https://raw.githubusercontent.com/Med-lemineHmd/nft_app_showcase/main/src/assets/expo02.png",
                }}
                style={styles.icon}
              />
              <Text style={styles.viewText}>view it on</Text>
              <Text style={styles.expoText}>Expo store</Text>
            </View>
          </View>

          <Image
            source={{
              uri: "https://pronft.netlify.app/static/media/home_hero.08651b83de3b3167695a.png",
            }}
            style={{ width: 350, height: 350 }}
          />
        </View>
      </ImageBackground>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flexDirection: "row",
    justifyContent: "center",
  },
  textContainer: {
    alignItems: "center",
  },
  title: {
    fontSize: 34,
    fontWeight: "bold",
    textAlign: "center",
    color: "#000",
    marginBottom: 10,
  },
  subtitle: {
    fontSize: 16,
    textAlign: "center",
    color: "#000",
    marginBottom: 20,
  },
  iconContainer: {
    alignItems: "center",
    marginBottom: 20,
  },
  icon: {
    width: 50,
    height: 50,
    marginBottom: 5,
  },
  viewText: {
    fontSize: 14,
    color: "#000",
  },
  expoText: {
    fontSize: 16,
    fontWeight: "bold",
    color: "#000",
  },
});
