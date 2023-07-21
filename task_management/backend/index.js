const express = require("express");
const app = express();
const mongoose = require("mongoose");
const { MONGO_DB_CONFIG } = require("./config/app.config");
const errors = require("./middleware/errors.js");
const PORT = process.env.PORT || 5000;
mongoose.Promise = global.Promise;
mongoose
    .connect(MONGO_DB_CONFIG.DB, {
        useNewUrlParser: true,
        useUnifiedTopology: true,
    })
    .then(
        () => {
            console.log("Database connected");
        },
        (error) => {
            console.log("Database can't be connected: " + error);
        }
    );

app.use(express.json());

app.use("/api", require("./routes/app.routes"));
app.use(errors.errorHandler);
app.listen(PORT, function () {
    console.log("Ready to Go!");
});