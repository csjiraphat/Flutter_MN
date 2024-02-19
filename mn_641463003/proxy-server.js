const express = require("express");
const cors = require("cors");
const axios = require("axios");

const app = express();

app.use(cors());

app.get("/directions", async (req, res) => {
  const { origin, destination, key } = req.query;
  try {
    const response = await axios.get(
      `https://maps.googleapis.com/maps/api/directions/json`,
      {
        params: {
          origin,
          destination,
          key,
        },
      }
    );
    res.send(response.data);
  } catch (error) {
    res.status(500).send(error);
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Proxy Server is running on port ${PORT}`);
});
